# Projeto Multicloud AWS e Azure

Esse projeto consiste na realização de um deploy de máquinas virtuais de forma simultânea na AWS e na Azure. O deploy será feito através de IaC com terraform.

Cada  infraestrutura  será  composta  de  uma  instância  de  servidor  incluindo  rede  virtual, subnet  e  endereço  ip.  Cada  instância  de  servidor  pode  ser  usada,  por  exemplo,  para  executar aplicações. 
Além disso, não há custo para executar este projeto pois ele utiliza a camada gratuita de ambos os provedores, AWS e Azure.

### Preparação:
Após realizar o git clone no seu repositório local, abra o arquivo providers.tf. Insira o ``subscription_id`` da conta da Azure na configuração do provider ``azurerm``, substituindo os caracteres "X".
Salve o arquivo e siga o procedimento adiante.

## Abra o terminal ou prompt de comando e navegue até a pasta onde está o Dockerfile

#### Execute o comando abaixo para criar a imagem Docker
> ```bash
> docker build -t jv-terraform-image:multicloud_project .
> ```

#### Execute o comando abaixo para criar o container Docker
> ```bash
> docker run -dit --name jv-p4 -v ./IaC:/iac jv-terraform-image:multicloud_project /bin/bash
> ```

## Dentro da interface do Docker, abra o terminal do container e siga os passos:

#### Verifique a versão do Terraform
> ```bash
> terraform version
> ```

#### Atualize a versão do Azure CLI (se necessário)
> ```bash
> az upgrade
> ```

#### Efetue login no Azure
> ```bash
> az login
> ```

#### Configuração das credenciais na AWS:
> ```bash
> aws configure
> ```

Obs.: insira as chaves de acesso e especifique a região ``us-east-1``, visto que é a determinada no arquivo ``providers.tf``

#### Sequência de comandos terraform para o deploy:

> ```bash
> terraform init
> terraform validate
> terraform plan -out jv.tfplan
> terraform apply jv.tfplan
> ```

Nesse ponto, as máquinas virtuais foram criadas simultaneamente na nuvem AWS e na Azure. Ambas podem ser acessadas na interface do usuário dos dois provedores.

#### Para finalizar o projeto, execute o comando abaixo no terminal do container Docker: 
> ```bash
> terraform destroy --auto-approve
> ```

## Referências:
- https://www.terraform.io/use-cases/multi-cloud-deployment
- https://aws.amazon.com/
- https://azure.microsoft.com/pt-br/
