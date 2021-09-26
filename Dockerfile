FROM alpine:latest

ENV KOPS_VERSION=v1.21.1
ENV KUBECTL_VERSION=v1.10.2
ENV TERRAFORM_VERSION=0.14.11
#ENV HELM_VERSION=v3.7.0
#https://github.com/helm/helm/archive/refs/tags/v3.7.0.tar.gz

RUN apk --no-cache update \
  && apk add --no-cache bash \ 
  && apk add --update openssl \
  && rm -rf /var/cache/apk/* \
  && apk --no-cache add ca-certificates python3 py3-pip py3-setuptools groff less \
  && apk --no-cache add --virtual build-dependencies curl \
  && pip --no-cache-dir install awscli \
  && curl -LO --silent --show-error https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 \
  && mv kops-linux-amd64 /usr/local/bin/kops \
  && curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  && mv kubectl /usr/local/bin/kubectl \
  && curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && mv terraform /usr/local/bin/terraform \
#   && curl -LO https://github.com/helm/helm/archive/refs/tags/v3.7.0.tar.gz \
#   && tar -xJvf helm-3.7.0.tar.gz \
#   && mv linux-amd64/helm /usr/local/bin/helm \
  && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
  && chmod 700 get_helm.sh \
  && ./get_helm.sh   \
  && chmod +x /usr/local/bin/kops /usr/local/bin/kubectl /usr/local/bin/terraform  /usr/local/bin/helm \
  && apk del --purge build-dependencies \
  && rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && rm -rf .get_helm.sh

CMD ["/bin/sh"]
