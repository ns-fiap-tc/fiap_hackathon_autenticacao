# Cria uma API do tipo HTTP, mais simples e moderna
resource "aws_apigatewayv2_api" "http_api" {
  name          = "${var.project_name}-http-api"
  protocol_type = "HTTP"

  tags = {
    Project = var.project_name
  }
}

# Cria o autorizador JWT que validará o token do Cognito
resource "aws_apigatewayv2_authorizer" "jwt_authorizer" {
  api_id           = aws_apigatewayv2_api.http_api.id
  name             = "cognito-jwt-authorizer"
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"] # Onde o token será procurado

  # Configuração do JWT
  jwt_configuration {
    # 'audience' deve ser o ID do cliente do Cognito
    audience = [aws_cognito_user_pool_client.user_pool_client.id]
    # 'issuer' é a URL do seu User Pool
    issuer = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.user_pool.id}"
  }
}

# --- Integração para o serviço de UPLOAD ---
resource "aws_apigatewayv2_integration" "ms_upload_alb_integration" {
  api_id = aws_apigatewayv2_api.http_api.id

  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  # Aponta para o DNS do ALB de UPLOAD
  integration_uri    = "http://${data.kubernetes_service.service-ms-upload.status[0].load_balancer[0].ingress[0].hostname}/{proxy}"
  timeout_milliseconds = 29000
}

# --- Integração para o serviço de PROCESSAMENTO ---
resource "aws_apigatewayv2_integration" "ms_processamento_alb_integration" {
  api_id = aws_apigatewayv2_api.http_api.id

  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  # Aponta para o DNS do ALB de PROCESSAMENTO
  integration_uri    = "http://${data.kubernetes_service.service-ms-processamento.status[0].load_balancer[0].ingress[0].hostname}/{proxy}"
  timeout_milliseconds = 29000
}

# --- Integração para o serviço de NOTIFICACAO ---
resource "aws_apigatewayv2_integration" "ms_notificacao_alb_integration" {
  api_id = aws_apigatewayv2_api.http_api.id

  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  # Aponta para o DNS do ALB de notificacao
  integration_uri    = "http://${data.kubernetes_service.service-ms-notificacao.status[0].load_balancer[0].ingress[0].hostname}/{proxy}"
  timeout_milliseconds = 29000
}


# Criamos uma para cada caminho, apontando para a integração correta

# --- Rota para /upload/* ---
resource "aws_apigatewayv2_route" "upload_route" {
  api_id = aws_apigatewayv2_api.http_api.id

  # Captura qualquer requisição que comece com /upload/
  # Ex: /upload, /upload/123, /upload/123/reviews
  route_key = "ANY /servico-upload/{proxy+}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt_authorizer.id

  # Aponta para a integração de UPLOAD
  target = "integrations/${aws_apigatewayv2_integration.ms_upload_alb_integration.id}"
}

# --- Rota para /processamento/* ---
resource "aws_apigatewayv2_route" "processamento_route" {
  api_id = aws_apigatewayv2_api.http_api.id

  # Captura qualquer requisição que comece com /processamento/
  route_key = "ANY /servico-processamento/{proxy+}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt_authorizer.id
  
  # Aponta para a integração de PROCESSAMENTO
  target = "integrations/${aws_apigatewayv2_integration.ms_processamento_alb_integration.id}"
}

# --- Rota para /notificacao/* ---
resource "aws_apigatewayv2_route" "notificacao_route" {
  api_id = aws_apigatewayv2_api.http_api.id

  # Captura qualquer requisição que comece com /notificacao/
  route_key = "ANY /servico-notificacao/{proxy+}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt_authorizer.id
  
  # Aponta para a integração de PROCESSAMENTO
  target = "integrations/${aws_apigatewayv2_integration.ms_notificacao_alb_integration.id}"
}

# Cria o estágio de "deploy" da API. É necessário para que a API seja acessível publicamente.
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id = aws_apigatewayv2_api.http_api.id

  name        = "$default" # O estágio padrão, acessível diretamente pela URL base
  auto_deploy = true
}