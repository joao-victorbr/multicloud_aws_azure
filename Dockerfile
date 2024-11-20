# Use a imagem oficial do Ubuntu como base
FROM ubuntu:latest

# Mantenedor da imagem (opcional)
LABEL maintainer="JV"

# Atualizar os pacotes do sistema e instalar dependências necessárias
RUN apt-get update && \
    apt-get install -y wget unzip curl git openssh-client iputils-ping sudo

# Definir a versão do Terraform (ajuste conforme necessário)
ENV TERRAFORM_VERSION=1.9.8

# Baixar e instalar Terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Criar a pasta /iac como um ponto de montagem para um volume
RUN mkdir /iac
VOLUME /iac

# Criar a pasta Downloads e instalar o AWS CLI e Azure CLI
RUN mkdir Downloads && \
    cd Downloads && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    curl -sL "https://aka.ms/InstallAzureCLIDeb" | sudo bash

# Definir o comando padrão para execução quando o container for iniciado
CMD ["/bin/bash"]