FROM python:3.12.5-slim-bookworm

ARG TARGETARCH

RUN mkdir -p /root/aws-cli

WORKDIR /root/aws-cli

RUN apt-get update -y && apt-get install -y aeson-pretty curl groff less unzip && apt-get clean && \
    if [ "$TARGETARCH" = "amd64" ]; then \
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"; \
    fi && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm awscliv2.zip && \
    rm -Rf aws
