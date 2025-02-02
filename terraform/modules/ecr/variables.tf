variable "repository_name" {
  type        = string
  description = "The name of the ECR repository"
}

variable "image_tag_mutability" {
  type        = string
  description = "The image tag mutability setting for the repository (MUTABLE or IMMUTABLE)"
  default     = "MUTABLE" # Good for development, consider IMMUTABLE for production
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "Value for image_tag_mutability must be either 'MUTABLE' or 'IMMUTABLE'."
  }
}

variable "scan_on_push" {
  type        = bool
  description = "Enable image scanning on push"
  default     = true # Recommended for security
}

variable "tags" {
  type        = map(string)
  description = "Optional tags to apply to the ECR repository"
  default     = {}
}