data "archive_file" "customer_lookup" {
  type        = "zip"
  source_dir  = "${path.root}/../../lambda/customer-lookup"
  output_path = "${path.root}/customer-lookup.zip"
}

resource "aws_iam_role" "lambda" {
  name = "${var.project_name}-${var.environment}-connect-lambda"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "customer_lookup" {
  function_name    = "${var.project_name}-${var.environment}-customer-lookup"
  role             = aws_iam_role.lambda.arn
  handler          = "handler.lambda_handler"
  runtime          = "python3.12"
  filename         = data.archive_file.customer_lookup.output_path
  source_code_hash = data.archive_file.customer_lookup.output_base64sha256
  timeout          = 5
  tags             = var.tags
}

output "customer_lookup_lambda_arn" {
  value = aws_lambda_function.customer_lookup.arn
}
