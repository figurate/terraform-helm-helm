variable "name" {
  description = "Service name"
}

variable "repository_url" {
  description = "Helm repository URL"
}

variable "chart" {
  description = "Helm chart name"
}

variable "config" {
  description = "A map of configuration settings"
  default     = {}
}
