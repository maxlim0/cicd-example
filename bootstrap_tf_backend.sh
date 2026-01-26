#!/usr/bin/env bash
set -euo pipefail

# ==========================================
# Terraform S3 Backend Bootstrap (S3 lockfile)
# Region: us-east-1 (default)
#
# Creates/Configures:
# - S3 bucket for Terraform state
# - Versioning ON
# - Default encryption ON (SSE-S3)
# - Block public access ON
# - Ownership controls: BucketOwnerEnforced
#
# DynamoDB is NOT used (use_lockfile = true)
# ==========================================

AWS_REGION="${AWS_REGION:-us-east-1}"

# You can override BUCKET_NAME and STATE_KEY from env
# Example:
#   BUCKET_NAME="my-tf-state-123" STATE_KEY="lab-infra/dev/vpc.tfstate" ./bootstrap_tf_backend_s3_lock.sh

ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text 2>/dev/null || true)"
if [[ -z "${ACCOUNT_ID}" ]]; then
  echo "ERROR: cannot get AWS account id. Check AWS credentials (aws sts get-caller-identity)."
  exit 1
fi

DEFAULT_BUCKET_NAME="tf-state-${ACCOUNT_ID}-${AWS_REGION}"
BUCKET_NAME="${BUCKET_NAME:-$DEFAULT_BUCKET_NAME}"

STATE_KEY="${STATE_KEY:-lab-infra/dev/vpc.tfstate}"

echo "==> AWS region:        ${AWS_REGION}"
echo "==> AWS account id:    ${ACCOUNT_ID}"
echo "==> Terraform bucket:  ${BUCKET_NAME}"
echo "==> Terraform key:     ${STATE_KEY}"
echo

command -v aws >/dev/null 2>&1 || { echo "ERROR: aws cli not found"; exit 1; }

echo "==> AWS identity:"
aws sts get-caller-identity --output table
echo

# ------------------------------------------
# Helpers
# ------------------------------------------
bucket_exists_and_accessible() {
  local bucket="$1"
  aws s3api head-bucket --bucket "$bucket" >/dev/null 2>&1
}

create_bucket_with_retry() {
  local bucket="$1"
  local region="$2"
  local max_attempts=12
  local attempt=1

  while (( attempt <= max_attempts )); do
    echo "==> Creating bucket attempt ${attempt}/${max_attempts}: ${bucket}"

    # us-east-1: do NOT pass LocationConstraint
    if [[ "$region" == "us-east-1" ]]; then
      if aws s3api create-bucket --bucket "$bucket" --region "$region" >/dev/null 2>&1; then
        echo "    Created bucket: ${bucket}"
        return 0
      fi
    else
      if aws s3api create-bucket \
        --bucket "$bucket" \
        --region "$region" \
        --create-bucket-configuration LocationConstraint="$region" >/dev/null 2>&1; then
        echo "    Created bucket: ${bucket}"
        return 0
      fi
    fi

    # If create-bucket failed, check if bucket became available anyway
    if bucket_exists_and_accessible "$bucket"; then
      echo "    Bucket already exists and is accessible: ${bucket}"
      return 0
    fi

    echo "    CreateBucket failed (maybe OperationAborted / eventual consistency). Retrying in 5s..."
    sleep 5
    attempt=$((attempt + 1))
  done

  echo "ERROR: Failed to create/access bucket after ${max_attempts} attempts."
  echo "Possible causes:"
  echo " - Bucket name is taken globally by someone else"
  echo " - AWS internal eventual consistency issue"
  echo "Try another BUCKET_NAME."
  return 1
}

put_bucket_versioning() {
  local bucket="$1"
  aws s3api put-bucket-versioning \
    --bucket "$bucket" \
    --versioning-configuration Status=Enabled >/dev/null
}

put_bucket_encryption_sse_s3() {
  local bucket="$1"
  aws s3api put-bucket-encryption \
    --bucket "$bucket" \
    --server-side-encryption-configuration '{
      "Rules": [{
        "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }]
    }' >/dev/null
}

put_public_access_block() {
  local bucket="$1"
  aws s3api put-public-access-block \
    --bucket "$bucket" \
    --public-access-block-configuration '{
      "BlockPublicAcls": true,
      "IgnorePublicAcls": true,
      "BlockPublicPolicy": true,
      "RestrictPublicBuckets": true
    }' >/dev/null
}

put_ownership_controls() {
  local bucket="$1"
  # Not all accounts/older buckets accept it immediately; ignore errors safely.
  aws s3api put-bucket-ownership-controls \
    --bucket "$bucket" \
    --ownership-controls '{
      "Rules": [{
        "ObjectOwnership": "BucketOwnerEnforced"
      }]
    }' >/dev/null 2>&1 || true
}

# ------------------------------------------
# Create/configure bucket
# ------------------------------------------
if bucket_exists_and_accessible "$BUCKET_NAME"; then
  echo "==> Bucket exists and is accessible: ${BUCKET_NAME}"
else
  echo "==> Bucket not accessible yet. Creating..."
  create_bucket_with_retry "$BUCKET_NAME" "$AWS_REGION"
fi

echo "==> Applying bucket configuration..."
echo "    - versioning: enabled"
put_bucket_versioning "$BUCKET_NAME"

echo "    - encryption: SSE-S3 enabled"
put_bucket_encryption_sse_s3 "$BUCKET_NAME"

echo "    - public access block: enabled"
put_public_access_block "$BUCKET_NAME"

echo "    - ownership controls: BucketOwnerEnforced"
put_ownership_controls "$BUCKET_NAME"

echo
echo "==> Done."
echo
echo "Paste this into envs/dev/backend.tf:"
echo "------------------------------------------------------------"
cat <<EOF
terraform {
  backend "s3" {
    bucket       = "${BUCKET_NAME}"
    key          = "${STATE_KEY}"
    region       = "${AWS_REGION}"
    encrypt      = true
    use_lockfile = true
  }
}
EOF
echo "------------------------------------------------------------"
echo
echo "Next:"
echo "  cd envs/dev"
echo "  terraform init"
echo "  terraform plan"
echo "  terraform apply"