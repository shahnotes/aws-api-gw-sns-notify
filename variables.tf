variable "author" {
  description = "The author name for this infrastructure."
  type        = string
}

variable "region" {
  description = "The region this infrastructure is deploying in."
  type        = string
  default     = "us-east-1"
}

variable "project_env" {
  description = "The environment this infrastructure is deploying in."
  type        = string
  default     = "dev"
}

variable "project_prefix" {
  description = "Prefix for the project"
  type        = string
}

variable "sns_email" {
  description = "Email to be used for notifications to."
  type        = string
}

variable "sns_topic_name" {
  description = "The name of the SNS topic to subscribe to."
  type        = string
}

variable "sns_rest_api_name" {
  description = "The name of the endpoint to subscribe to."
  type        = string
}

