resource "aws_s3_bucket" "tahabucketfore1" {
    bucket = "tahass3bucketfore1"
    versioning {
        enabled = true
    }
    lifecycle_rule {
        id      = "lifecycleruletahas3fore1"
        enabled = true
    
    transition {
        days          = 30
        storage_class = "STANDARD_IA"
    }
    transition {
        days          = 60
        storage_class = "GLACIER"
    }
    }
}

resource "aws_s3_bucket_object" "tahas3bofore1" {
    bucket = aws_s3_bucket.tahabucketfore1.id
    key    = "index.html"
    acl    = "public-read"
    source = "./index.html"
    content_type = "text/html"
}

