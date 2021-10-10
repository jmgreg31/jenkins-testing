terraform {
  backend "s3" {
    bucket  = "jmgreg31"
    key     = "discordbot/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

resource "aws_lambda_function" "bot_lambda" {
  filename         = "lambdaFunction.zip"
  function_name    = "discordbot_griz31testbot"
  role             = "arn:aws:iam::894518317441:role/jmgreg31-access"
  handler          = "lambdaFunction.lambda_handler"
  source_code_hash = filebase64sha256("lambdaFunction.zip")
  runtime          = "python3.7"
}
