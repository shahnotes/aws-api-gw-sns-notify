variable "author" {
  description = "The author name for this infrastructure."
  type        = string
}

variable "region" {
  description = "The region this infrastructure is deploying in."
  type        = string
  default     = "us-east-1"
}

variable "sns_email" {
  description = "Email to be used for notifications to."
  type        = string
}

