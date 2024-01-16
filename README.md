# aws-ci-cd-pipeline

A comprehensive guide for setting up an AWS environment for CodeDeploy with GitHub Actions integration.

---

## Prerequistes
- Create Amazon S3 bucket for uploading source code zip
- Create IAM Role for EC2 Instance
- Create EC2 Instance
- Create Service Role for CodeDeploy
- Create Amazon CodeDeploy Application
- Create Amazon CodeDeploy Deployment group
- Configure AWS credentials for GitHub Actions
- Update GitHub Actions Secrets

---
### Create Amazon S3 bucket for uploading source code zip

### Create IAM Instance Profile
1. Create IAM Policy
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
                "arn:aws:s3:::your-s3-bucket-name/*",
                "arn:aws:s3:::aws-codedeploy-ap-northeast-2/*"
            ]
        }
    ]
}
```

2. Create IAM Role for EC2 Instance (=Instance Profile)
- Service/Use Case : `EC2`
- Permissions polices :
    - **AmazonSSMManagedInstanceCore**
    - **IAM Policy** created by (1) 


### Create EC2 Instance
- Name : `instance`
- OS : `Amazon Linux 2023`
- Security Group 
    - Allow HTTP 
    - Allow SSH 
- Instance profile : created by above
- User data for installing CodeDeploy Agent
```
sudo yum update
sudo yum install ruby -y
sudo yum install wget -y
cd /home/ec2-user
wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
systemctl status codedeploy-agent
```

### Create Service Role for CodeDeploy
- Service/Use Case : `CodeDeploy`
- Permissions policies : 
    - **AWSCodeDeployRole**
- Role name : `CodeDeployServiceRole`

### Create Amazon CodeDeploy Application 
- Application name : `application`
- Compute platform : `EC2/On-premises`

### Create Amazon CodeDeploy Deployment group
- Deployment group name : `deployment-group`
- Service role : `CodeDeployServiceRole`
- Deployment type : `In-Place`
- Environment configuration : `Amazon EC2 instances`
    - Key : `Name`, Value : `instance`
- Install AWS CodeDeploy Agent : `Never`
- Deployment configuration : `CodeDeployDefault.AllAtOnce`

### Configure AWS credentials for GitHub Actions
1. Add **IAM Identity Providers** 
- Provider type : `OpenID Connect`
- Provider URL : `https://token.actions.githubusercontent.com`
- Audiences: `sts.amazonaws.com`

2. Create IAM Policy
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "codedeploy:CreateDeployment",
                "codedeploy:GetApplication",
                "codedeploy:GetDeploymentGroup",
                "codedeploy:GetDeploymentConfig",
                "codedeploy:RegisterApplicationRevision"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::your-s3-bucket-name/*"
        }
    ]
}
```

3. Create IAM Role for Github Actions
- Web identity : `token.actions.githubusercontent.com`
- Audience : `sts.amazonaws.com`
- GitHub organization : `github organization or personal account id`
- GitHub repository : `(optional)`
- GitHub branch : `(optional)`
- Permissions polices : **IAM Policy** created by (2) 


### Update GitHub Actions Secrets
- BUCKET_NAME
- CODEDEPLOY_APP_NAME : `application`
- DEPLOYMENT_GROUP_NAME : `deployment-group`
- ROLE_NAME : IAM Role for Github Actions