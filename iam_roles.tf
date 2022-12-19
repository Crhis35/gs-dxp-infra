#####Jenkins
resource "aws_iam_role" "gs_jenkins" {
  name = "GSJenkinsRole"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}


resource "aws_iam_role_policy_attachment" "JenkinsAmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  role       = aws_iam_role.gs_jenkins.name
}

resource "aws_iam_role_policy_attachment" "JenkinsAmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.gs_jenkins.name
}

resource "aws_iam_instance_profile" "gs_jenkins" {
  name = "GSJenkins"
  role = aws_iam_role.gs_jenkins.name
}

resource "aws_iam_policy" "jenkinsslavepolicy" {
  name = "JenkinsAccessEC2slavemachine"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeSpotFleetInstances",
          "ec2:ModifySpotFleetRequest",
          "ec2:CreateTags",
          "ec2:DescribeRegions",
          "ec2:DescribeInstances",
          "ec2:TerminateInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeSpotFleetRequests"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:UpdateAutoScalingGroup"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:ListInstanceProfiles",
          "iam:ListRoles",
          "iam:PassRole"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkinsslavepolicy" {
  policy_arn = aws_iam_policy.jenkinsslavepolicy.arn
  role       = aws_iam_role.gs_jenkins.name
}

#####Bastion
resource "aws_iam_role" "gs_bastion" {
  name = "GSBastionRole"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_instance_profile" "gs_bastion" {
  name = "GSBastion"
  role = aws_iam_role.gs_bastion.name
}
