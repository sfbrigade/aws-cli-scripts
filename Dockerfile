FROM python:3.9.19-slim-bookworm

ARG TARGETARCH

RUN mkdir -p /root/aws-cli

WORKDIR /root/aws-cli

RUN apt-get update -y && apt-get install -y aeson-pretty curl git groff less make unzip && apt-get clean

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"; \
    fi && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm awscliv2.zip && \
    rm -Rf aws

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" -o "aws-sam-cli.zip"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-arm64.zip" -o "aws-sam-cli.zip"; \
    fi && \
    unzip aws-sam-cli.zip -d sam-installation && \
    ./sam-installation/install && \
    rm aws-sam-cli.zip && \
    rm -Rf sam-installation
