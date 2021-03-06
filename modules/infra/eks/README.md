Creates and manages a EKS cluster on Amazon Web Services. 

This requires the terraform aws provider to authethenticate with AWS:

* Create an IAM account in AWS for your account with the appropriate permissions for EKS and its resources
* Register a profile for your IAM account: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html
* Set your `AWS_PROFILE` environment variable the name you used above

The environment value `AWS_PROFILE` should be accessible in the context that terraform is running. If you create a`.env` file at the root of this project and define it there, it will be loaded by the container automatically and the file will NOT be checked into SCM via `.gitignore`. The containers entrypoint will also read this value and make it avaiable to the aws cli in the console.

The user account running Terraform for this module will required the following permissions:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "iam:CreateRole",
                "kms:ListResourceTags",
                "iam:AttachRolePolicy",
                "iam:PutRolePolicy",
                "autoscaling:*",
                "iam:ListInstanceProfilesForRole",
                "iam:PassRole",
                "iam:DetachRolePolicy",
                "kms:GetKeyRotationStatus",
                "kms:ScheduleKeyDeletion",
                "iam:DeleteRolePolicy",
                "kms:DescribeKey",
                "kms:CreateKey",
                "kms:EnableKeyRotation",
                "iam:GetRole",
                "kms:UpdateKeyDescription",
                "kms:GetKeyPolicy",
                "iam:DeleteRole",
                "elasticloadbalancing:*",
                "kms:DisableKey",
                "ecs:*",
                "kms:CreateAlias",
                "ecr:*",
                "ec2:*",
                "route53:AssociateVPCWithHostedZone",
                "eks:*",
                "kms:DeleteAlias",
                "iam:GetRolePolicy",
                "iam:CreateServiceLinkedRole",
                "iam:CreateInstanceProfile",
                "iam:GetInstanceProfile",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:DeleteInstanceProfile"
            ],
            "Resource": "*"
        }
    ]
}
```

* [inputs](./variables.tf)
* [outputs](./outputs.tf)