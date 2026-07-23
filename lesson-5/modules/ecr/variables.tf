variable "ecr_name" {
  type = string
}

variable "scan_on_push" {
  type = bool
}


variable "allowed_principals" {
  type        = list(string)
  default     = []
  description = "Список IAM ARN користувачів або ролей, яким дозволено доступ до ECR. Якщо порожньо, за замовчуванням використовується поточний акаунт."
}