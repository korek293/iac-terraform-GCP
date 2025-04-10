resource "aws_s3_bucket" "this" {
  provider = aws
  bucket   = local.bucket_name

  tags = {
    Environment = "Test"
  }
}

data "aws_iam_policy_document" "this_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.this_role.arn]
    }

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.this.arn
    ]
  }
}

resource "null_resource" "this_file" {
  provisioner "local-exec" {
    command = "echo 'This is Terraform task by ...' > ${path.root}/files/index.html"
  }
}

resource "aws_s3_object" "this_file" {
  provider = aws
  bucket   = aws_s3_bucket.this.id
  key      = "index.html"
  source   = "${path.root}/files/index.html"
}

resource "aws_s3_bucket_policy" "this_policy" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this_policy.json
}
