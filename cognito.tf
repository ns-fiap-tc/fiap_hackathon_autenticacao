# Cria o pool de usuários do Cognito
resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.project_name}-user-pool"

  # Exige que o email seja verificado para o usuário poder fazer login
  auto_verified_attributes = ["email"]

  # Define a política de senha
  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  tags = {
    Project = var.project_name
  }
}

# Cria um cliente de aplicativo para o User Pool.
# A aplicação front-end/mobile usará este ID para se comunicar com o Cognito.
resource "aws_cognito_user_pool_client" "user_pool_client" {
  name = "${var.project_name}-app-client"

  user_pool_id = aws_cognito_user_pool.user_pool.id

  # Desativa a geração de um segredo de cliente, ideal para aplicações web (SPAs)
  generate_secret = false

  # Habilita o fluxo de autenticação com usuário e senha
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]
}

# Primeiro, cria o usuário com uma senha temporária.
resource "null_resource" "create_temp_user" {
  depends_on = [
    aws_cognito_user_pool.user_pool
  ]

  provisioner "local-exec" {
    command = <<EOT
      aws cognito-idp admin-create-user \
      --user-pool-id "${aws_cognito_user_pool.user_pool.id}" \
      --username "${var.usuario_padrao}" \
      --user-attributes Name="email",Value="admin@seuprojeto.com" \
      --temporary-password "${var.senha_usuario_padrao}" \
      --message-action SUPPRESS
    EOT

    interpreter = ["/bin/bash", "-c"]
  }
}

# Em seguida, define a senha como permanente para o usuário recém-criado e o confirma.
resource "null_resource" "set_user_password_permanent" {
  depends_on = [
    null_resource.create_temp_user
  ]

  provisioner "local-exec" {
    command = <<EOT
      aws cognito-idp admin-set-user-password \
      --user-pool-id "${aws_cognito_user_pool.user_pool.id}" \
      --username "${var.usuario_padrao}" \
      --password "${var.senha_usuario_padrao}" \
      --permanent
    EOT
    
    interpreter = ["/bin/bash", "-c"]
  }
}