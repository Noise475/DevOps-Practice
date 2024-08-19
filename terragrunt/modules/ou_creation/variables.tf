# modules/ou_creation/variables.tf
variable "ou_names" {
  description = "List of OU names to create"
  type        = list(object({ name = string }))
}

variable "parent_ou_id" {
  description = "ID of the parent OU (optional)"
  type        = string
  default     = "null"
}

variable "environment" {
  description = "Current Environment"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}
