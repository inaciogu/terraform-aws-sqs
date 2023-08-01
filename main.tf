provider "aws" {
  access_key = ""
  secret_key = ""
  region = "us-east-1"
}

resource "aws_sqs_queue" "example_queue" {
  name = "example_queue"
}

resource "aws_sns_topic" "example_topic" {
  name = "example_topic"
}

resource "aws_sns_topic_subscription" "example_topic_sub" {
  topic_arn = aws_sns_topic.example_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.example_queue.arn
}

resource "aws_sqs_queue_policy" "example_queue_policy" {
  queue_url = aws_sqs_queue.example_queue.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.example_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.example_topic.arn}"
        }
      }
    }
  ]
}
EOF
}