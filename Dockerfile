FROM ubuntu:24.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -yq install unzip curl less groff jq && rm -rf /var/lib/apt/lists/*

ENV KUBECTL_VERSION=v1.34.1
ENV AWSCLI_VERSION=2.31.34
ENV EKSCTL_VERSION=v0.217.0
ENV HELM_VERSION=v3.19.1

WORKDIR /root
RUN curl -sSfL -o kubectl.sha256 https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256
RUN curl -sSfL -o kubectl https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
RUN openssl sha1 -sha256 kubectl && chmod +x kubectl && mv kubectl /usr/local/bin/ && rm kubectl.sha256
RUN kubectl version --client

RUN curl -sSf "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip &&  ./aws/install -i /usr/local/aws-cli -b /usr/local/bin && rm awscliv2.zip && rm -r aws
RUN aws --version

RUN curl -sSfL "https://github.com/eksctl-io/eksctl/releases/download/${EKSCTL_VERSION}/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp && mv /tmp/eksctl /usr/local/bin
RUN eksctl version

RUN curl -sSfL "https://github.com/helm/helm/releases/download/${HELM_VERSION}/helm-${HELM_VERSION}-linux-amd64.tar.gz.sha256.asc"
RUN curl -sSfL "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" -O
RUN openssl sha1 -sha256 helm-${HELM_VERSION}-linux-amd64.tar.gz && tar xf helm-${HELM_VERSION}-linux-amd64.tar.gz -C /tmp && mv /tmp/linux-amd64/helm /usr/local/bin
RUN helm version

RUN aws --version
RUN kubectl version --client
RUN eksctl version
RUN helm version
