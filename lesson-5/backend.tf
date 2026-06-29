terraform {
  backend "s3" {
    bucket       = "lesson-5-kalianov-bucket"
    key          = "lesson-5/terraform.tfstate"
    region       = "us-west-2"
    use_lockfile = true
    encrypt      = true
  }
}