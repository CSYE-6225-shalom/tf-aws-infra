resource "aws_iam_role" "cloudwatch_agent_role" {
  name = var.cloudwatch_agent_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.cloudwatch_agent_role.name
}

resource "aws_iam_instance_profile" "cloudwatch_agent_instance_profile" {
  name = "cloudwatch-agent-instance-profile"
  role = aws_iam_role.cloudwatch_agent_role.name
}
