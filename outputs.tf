output "api_gateway_invoke_url" {
  description = "A URL base para invocar a API Gateway."
  value       = aws_apigatewayv2_stage.default_stage.invoke_url
}

output "cognito_user_pool_id" {
  description = "O ID do Cognito User Pool."
  value       = aws_cognito_user_pool.user_pool.id
}

output "cognito_user_pool_client_id" {
  description = "O ID do cliente do Cognito User Pool."
  value       = aws_cognito_user_pool_client.user_pool_client.id
}