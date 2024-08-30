# modules/ou_creation/variables.tf
variable "ou_names" {
  description = "List of OU names to create"
  type        = map(string)
}

variable "parent_ou_id" {
  description = "ID of the parent OU (optional)"
  type        = string
  default     = "null"
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}
