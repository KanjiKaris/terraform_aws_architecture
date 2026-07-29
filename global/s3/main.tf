provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "kanji-terraform-state-bucket"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "kanji-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# adding an alias provider to the configuration
provider "aws" {
  alias  = "replica"
  region = "us-west-2"
}

resource "aws_s3_bucket" "terraform_state_replica" {
  provider = aws.replica
  bucket   = "kanji-terraform-state-bucket-replica"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "replica_versioning" {
  provider = aws.replica
  bucket   = aws_s3_bucket.terraform_state_replica.id

  versioning_configuration {
    status = "Enabled"
  }
}

# iam policy for replication
data "aws_iam_policy_document" "replication_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "replication" {
  name               = "s3-bucket-replication-role"
  assume_role_policy = data.aws_iam_policy_document.replication_assume_role.json
}

data "aws_iam_policy_document" "replication" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetReplicationConfiguration", "s3:ListBucket"]
    resources = [aws_s3_bucket.terraform_state.arn]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObjectVersionForReplication", "s3:GetObjectVersionAcl"]
    resources = ["${aws_s3_bucket.terraform_state.arn}/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:ReplicateObject", "s3:ReplicateDelete"]
    resources = ["${aws_s3_bucket.terraform_state_replica.arn}/*"]
  }
}

resource "aws_iam_role_policy" "replication" {
  name   = "s3-bucket-replication-policy"
  role   = aws_iam_role.replication.id
  policy = data.aws_iam_policy_document.replication.json
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  # Must run on the default (source-region) provider
  depends_on = [aws_s3_bucket_versioning.versioning]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id     = "state-bucket-replication"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.terraform_state_replica.arn
      storage_class = "STANDARD"
    }
  }
}