# FIAP Hackaton - Autenticação e API Gateway
Repositório com o código terraform para provisionamento da autenticação e api gateway para o hackathon

Este é o repositório que contém o provisionamento da auteticação e api gateway da aplicação [FIAP Hackathon](https://github.com/ns-fiap-tc/fiap_hackathon_doc). Nele você encontrará arquivos de configuração do Terraform que definem o funcionamento do cognito com autenticação e api gateway com rotas e validação do JWT.

<details>
  <summary>Detalhamento execução do projeto</summary>

## 👟 Passos para o provisionamento
Este projeto possui um ecossistema composto por múltiplos repositórios que se comunicam entre si e também utilizam GitHub Actions para provisionamento ou deploy automatizado.

> Para completo funcionamento da plataforma, é necessário seguir o seguinte fluxo de provisionamento:
> 1. A provisão do repositório da infra base: [infra-base](https://github.com/ns-fiap-tc/fiap_hackathon_infra_base);
> 2. A provisão do repositório do banco de dados: [infra-bd](https://github.com/ns-fiap-tc/fiap_hackathon_infra_bd);
> 3. A provisão do repositório do microsserviço de upload: [fiap_hackathon_ms_upload](https://github.com/ns-fiap-tc/fiap_hackathon_ms_upload);
> 4. A provisão do repositório do microsserviço de notificação: [fiap_hackathon_ms_notificacao](https://github.com/ns-fiap-tc/fiap_hackathon_ms_notificacao);
> 5. A provisão do repositório do microsserviço de processamento: [fiap_hackathon_ms_processamento](https://github.com/ns-fiap-tc/fiap_hackathon_ms_processamento);
> 6. A provisão do repositório do microsserviço de extração de frames: [fiap_hackathon_ms_frameextractor](https://github.com/ns-fiap-tc/fiap_hackathon_ms_frameextractor);
> 7. A provisão deste repositório: [fiap_hackathon_autenticacao](#como-rodar-o-projeto); 

## 🚀 Como rodar o projeto

### 💻 Localmente

<details>
  <summary>Passo a passo</summary>

#### Pré-requisitos

Antes de começar, certifique-se de ter os seguintes itens instalados e configurados em seu ambiente:

1. **Terraform**: A ferramenta que permite definir, visualizar e implantar a infraestrutura de nuvem.
2. **AWS CLI**: A interface de linha de comando da AWS.
3. **Credenciais AWS válidas**: Você precisará de uma chave de acesso e uma chave secreta para autenticar com a AWS (no momento, o repositório usa chaves e credenciais fornecidas pelo [AWS Academy](https://awsacademy.instructure.com/) e que divergem de contas padrão). Tais credenciais devem ser inseridas no arquivo `credentials` que fica dentro da pasta `.aws`
4. **Bucket S3 criado na AWS convencional (que não seja na aws academy)**: Você precisará de uma chave de acesso e uma chave secreta para autenticar com a AWS e conectar ao S3. Tal abordagem foi necessária pois a AWS academy não permite a criação de roles e isso inviabilizou a comunicação dos serviços rodando no eks com o S3 da AWS academy. Com isso a solução foi criar um bucket com uma role específica para ele em um conta convencional da AWS

## Como usar

1. **Clonar o repositório**:

```bash
git clone https://github.com/ns-fiap-tc/fiap_hackathon_autenticacao
```

2. **Acesse o diretório do repositório clonado, por exemplo**:

```bash
cd fiap_hackathon_autenticacao
```

3. **Defina as variáveis necessárias ao nível de ambiente, criando um arquivo `.env` de acordo com o arquivo contido em cada repositório `.env.exemplo`. Exemplo:**:

```bash
DOCKERHUB_USERNAME="dockerhub_username"
DOCKERHUB_ACCESS_TOKEN="dokerhub_token"
```

4. **Inicialize o diretório Terraform**:

```bash
terraform init
```

5. **Visualize as mudanças que serão feitas**:

```bash
./terraform.sh plan
```

6. **Provisione a infraestrutura**:

```bash
./terraform.sh apply -auto-approve
```

7. **Para destruir a infraestrutura provisionada**:

```bash
./terraform.sh destroy -auto-approve
```
</details>
</details>
