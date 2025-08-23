# AWS provider configuration
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto para identificar os recursos."
  type        = string
  default     = "hacka-fiap"
}

variable "usuario_padrao" {
  description = "Nome do usuário padrão ao criar o pool."
  type        = string
  default     = "admin"
}

variable "senha_usuario_padrao" {
  description = "Nome do usuário padrão ao criar o pool."
  type        = string
  default     = "12345678"
}