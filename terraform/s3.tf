resource "aws_s3_bucket" "remote_s3" {
  bucket = "tws-junoon-state-dheeraj"

  tags = {
    Name        = "tws-junoon-state-dheeraj"
    
  }
}