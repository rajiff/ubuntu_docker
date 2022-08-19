FROM ubuntu:22.10

WORKDIR $HOME

RUN apt-get update && \
    apt-get install -y gnupg && 
    apt-get install -y software-properties-common && \
    apt-get install -y wget curl git unzip vim python3-pip groff

## Check architecture by command "uname -m"
ARG LINUX_ARCH=aarch64 # Apple M1 processor
# ARG LINUX_ARCH=x86_64 # Intel based processors

# Install awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-${LINUX_ARCH}.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    cd $HOME && ./aws/install -i /usr/local/aws-cli -b /usr/local/bin && aws --version

## Install terraform
ARG TERRAFORM_VERSION=1.2.7
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && chmod +x /usr/local/bin/terraform && terraform --version

## Install kubectl (command line utility for Kubernetes API client)
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" && \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    kubectl version --client --output=yaml

## Install Helm

## Install Nodejs
