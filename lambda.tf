data "archive_file" "lambda_source" {
  type        = "zip"
  source_dir  = "${path.module}/src/"
  output_path = "${path.module}/src/package.zip"
}

resource "aws_lambda_function" "api" {
  depends_on       = ["data.archive_file.lambda_source"]
  function_name    = "minecraft_proxy"
  description      = "proxy lambda to execute on the mc server"
  filename         = "${path.module}/src/package.zip"
  source_code_hash = "${data.archive_file.lambda_source.output_base64sha256}"
  role             = "${aws_iam_role.lambda.arn}"
  handler          = "main.lambda_handler"
}
resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.example.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.minecraft.execution_arn}/*/*"
}
