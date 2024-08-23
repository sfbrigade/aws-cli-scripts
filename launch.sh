#!/bin/bash

read -p "App name (lowercase, letters, numbers, hyphen only): " APP_NAME
read -p "Base domain for the instance: " DOMAIN
read -p "Contact email to use for LetsEncrypt SSL registration: " LETSENCRYPT_EMAIL
read -p "Instance type [t2.micro]: " INSTANCE_TYPE
INSTANCE_TYPE=${INSTANCE_TYPE:=t2.micro}

# determine architecture type from instance type
if [[ "$INSTANCE_TYPE" =~ g\. ]]; then
  TARGET_ARCH=arm64
else
  TARGET_ARCH=amd64
fi

IMAGE_ID=`aws ssm get-parameters-by-path --path /aws/service/debian/release/bookworm/latest --output text | grep -m 1 -oP "${TARGET_ARCH}[[:blank:]]+String[[:blank:]]+\K(ami-[^[:blank:]]+)"`

# create the key pair for CDN signing
openssl genrsa -out private_key.pem 2048
openssl rsa -pubout -in private_key.pem -out public_key.pem
PUBLIC_KEY=`cat public_key.pem`
PRIVATE_KEY=`cat private_key.pem`
PRIVATE_KEY=${PRIVATE_KEY//
/"\\n"}

aws cloudformation create-stack --capabilities CAPABILITY_NAMED_IAM --stack-name dokku-${APP_NAME} --template-body file://./launch.json --parameters ParameterKey=ApplicationName,ParameterValue=$APP_NAME ParameterKey=LetsEncryptEmail,ParameterValue=$LETSENCRYPT_EMAIL ParameterKey=CDNSigningPrivateKey,ParameterValue="$PRIVATE_KEY" ParameterKey=CDNSigningPublicKey,ParameterValue="$PUBLIC_KEY" ParameterKey=DokkuHostname,ParameterValue="$DOMAIN" ParameterKey=InstanceImageId,ParameterValue="$IMAGE_ID" ParameterKey=InstanceType,ParameterValue="$INSTANCE_TYPE"

# wait for key pair to become available
while : ; do
  KEY_NAME=`aws ec2 describe-key-pairs --filters Name=key-name,Values=dokku-${APP_NAME}-key-pair --query KeyPairs[*].KeyPairId --output text`
  if [ "$KEY_NAME" != "" ]; then
    break
  fi
  sleep 1
done

# download into a pem file in ~/.ssh
aws ssm get-parameter --name /ec2/keypair/${KEY_NAME} --with-decryption --query Parameter.Value --output text > ~/.ssh/dokku-${APP_NAME}-key-pair.pem
chmod 600 ~/.ssh/dokku-${APP_NAME}-key-pair.pem
