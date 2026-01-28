terraform {
  backend "s3" {
    bucket         = "maxim-lab-tf-state-978937106980-us-east-1"
    key            = "lab-bootstarp/dev/vpc.tfstate"
    region         = "us-east-1"
    use_lockfile   = "true"
    encrypt        = true
  }
}