resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(local.common_tags, {
    Name = "${local.name}-vpc"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${local.name}-igw"
  })
}

# Public subnets
resource "aws_subnet" "public" {
  for_each = {
    for idx, az in var.azs : az => {
      az   = az
      cidr = var.public_subnet_cidrs[idx]
      idx  = idx
    }
  }

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.value.az
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    local.eks_public_subnet_tags,
    {
      Name = "${local.name}-public-${each.value.az}"
      Tier = "public"
    }
  )
}

# Private app subnets
resource "aws_subnet" "private_app" {
  for_each = {
    for idx, az in var.azs : az => {
      az   = az
      cidr = var.private_app_subnet_cidrs[idx]
      idx  = idx
    }
  }

  vpc_id            = aws_vpc.this.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr

  tags = merge(
    local.common_tags,
    local.eks_private_subnet_tags,
    {
      Name = "${local.name}-private-app-${each.value.az}"
      Tier = "private"
      Zone = "app"
    }
  )
}

# Private data subnets (optional)
resource "aws_subnet" "private_data" {
  for_each = {
    for idx, az in var.azs : az => {
      az   = az
      cidr = try(var.private_data_subnet_cidrs[idx], null)
      idx  = idx
    } if length(var.private_data_subnet_cidrs) > 0
  }

  vpc_id            = aws_vpc.this.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr

  tags = merge(
    local.common_tags,
    local.eks_private_subnet_tags,
    {
      Name = "${local.name}-private-data-${each.value.az}"
      Tier = "private"
      Zone = "data"
    }
  )
}

# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${local.name}-rt-public"
  })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# NAT (single) in the first public subnet
resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"

  tags = merge(local.common_tags, {
    Name = "${local.name}-nat-eip"
  })
}

resource "aws_nat_gateway" "this" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id

  # Place NAT into the first public subnet (by az order)
  subnet_id = aws_subnet.public[var.azs[0]].id

  tags = merge(local.common_tags, {
    Name = "${local.name}-nat"
  })

  depends_on = [aws_internet_gateway.this]
}

# Private route tables per AZ (even with single NAT, separate RTs are fine)
resource "aws_route_table" "private_app" {
  for_each = aws_subnet.private_app

  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${local.name}-rt-private-app-${each.key}"
  })
}

resource "aws_route" "private_app_nat" {
  for_each = var.enable_nat_gateway ? aws_route_table.private_app : {}

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

resource "aws_route_table_association" "private_app" {
  for_each = aws_subnet.private_app

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_app[each.key].id
}

# Private data route tables (optional)
resource "aws_route_table" "private_data" {
  for_each = aws_subnet.private_data

  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${local.name}-rt-private-data-${each.key}"
  })
}

resource "aws_route" "private_data_nat" {
  for_each = var.enable_nat_gateway ? aws_route_table.private_data : {}

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

resource "aws_route_table_association" "private_data" {
  for_each = aws_subnet.private_data

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_data[each.key].id
}