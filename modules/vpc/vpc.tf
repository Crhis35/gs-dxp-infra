resource "aws_vpc" "this" {
  cidr_block = var.cidr

  tags = merge(
    {
      "Name" = format("%s-%s", var.name, var.env)
    },
    var.tags,
  )
}

################
# Public subnet
################

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    {
      "Name" = format(
        "%s-${var.public_subnet_suffix}-%s-%s",
        var.name,
        var.env,
        element(var.azs, count.index),
    ) },
    var.tags, var.public_eks_tags
  )
}

#################
# Private subnet
#################

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = element(var.azs, count.index)

  tags = merge(
    {
      "Name" = format(
        "%s-${var.private_subnet_suffix}-%s-%s",
        var.name,
        var.env,
        element(var.azs, count.index),
      )
    }, var.tags, var.private_eks_tags,
  )
}
###################
# Internet Gateway
###################
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name" = format("%s-%s-IGW", var.name, var.env)
    },
    var.tags,
  )
}

### Elastic IP ###
resource "aws_eip" "aws_nat_eip" {
  vpc = true
}

### NAT Gateway ###
resource "aws_nat_gateway" "this" {
  subnet_id = aws_subnet.public[0].id

  allocation_id = aws_eip.aws_nat_eip.id

  tags = merge(
    {
      "Name" = format("%s-Nat-Gateway-%s", var.name, var.env)
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.this]
}


################
# Publi? routes
################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name" = format("%s-${var.public_subnet_suffix}-%s-routetable", var.name, var.env)
    },
    var.tags,
  )
}

resource "aws_route" "public_internet_gateway" {

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}

#################
# Private routes
# There are as many routing tables as the number of NAT gateways
#################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    {
      "Name" = format("%s-${var.private_subnet_suffix}-%s-routetable", var.name, var.env)
    },
    var.tags,
  )
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id

  timeouts {
    create = "5m"
  }
}


##########################
# Route table association
##########################
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.this.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
