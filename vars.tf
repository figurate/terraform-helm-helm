variable "name" {
  description = "Service name"
}

variable "repository_url" {
  description = "Optional Helm repository URL"
  default     = null
}

variable "chart" {
  description = "Helm chart repository path. May also refer to a local path or a remote package (tgz)."
}

variable "env" {
  description = "A map of environment settings"
  default     = {}
}

variable "env_sensitive" {
  description = "A map of sensitive environment settings"
  default     = {}
}
