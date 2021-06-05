# perl-on-aws-app-runner
Run PSGI app on [AWS App Runner](https://aws.amazon.com/apprunner/)

## Build the Image

```console
git clone git@github.com:shogo82148/perl-on-aws-app-runner.git
docker build -t perl-test .
```

## Push the Image to ECR

Open [ECR (Amazon Elastic Container Registry) service on AWS Management Console](https://console.aws.amazon.com/apprunner/home) and create a new ECR Repository.
And then, push the image to the repository.

```console
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.ap-northeast-1.amazonaws.com
docker tag perl-test:latest 123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/perl-test:latest
docker push 123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/perl-test:latest
```

## Create a New Service on AWS App Runner

Open [AWS App Runner service on AWS Management Console](https://console.aws.amazon.com/apprunner/home) and create a new service.

- Source
    - **Repository type**: Container registry
    - **Provider**: Amazon ECR
    - **Container image URI**: `123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/perl-test:latest`
- Deployment settings
    - **Deployment trigger**: Automatic
    - **ECR access role**: Create new service role (or "Use existing service role" if you have already created it)

Wait for creating the service.
After that, you can see the "Hello world" message on https://xxxxxxxx.ap-northeast-1.awsapprunner.com/
