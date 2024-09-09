data "aws_iam_policy" "this" {
  arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_cloudformation_stack" "this" {
  name = "IAM-USERS-S3"

  template_body = <<JSON
{
    "Parameters": {
        "sallyPassword": {
            "Type": "String",
            "Description": "IAM User Sally's Password"
        }
    },
    "Resources": {
        "catpics": {
            "Type": "AWS::S3::Bucket"
        },
        "animalpics": {
            "Type": "AWS::S3::Bucket"
        },
        "sally": {
            "Type": "AWS::IAM::User",
            "Properties": {
                "ManagedPolicyArns": [
                    "${data.aws_iam_policy.this.arn}"
                ],
                "LoginProfile": {
                    "Password": { "Ref": "sallyPassword" },
                    "PasswordResetRequired": true
                }
            }
        },
        "policy": {
            "Type": "AWS::IAM::ManagedPolicy",
            "Properties": {
                "Description": "Allow access to all S3 buckets except catpics",
                "Name": "AllowAllS3ExceptCats",
                "PolicyDocument": {
                    "Version": "2012-10-17",
                    "Statement": [
                        {
                            "Effect": "Allow",
                            "Action": "s3:*",
                            "Resource": "*",
                            "Condition": {
                                "StringNotEquals": {
                                    "s3:prefix": "catpics"
                                }
                            }
                        }
                    ]
                }
            }
        }
    }
}
JSON
}
