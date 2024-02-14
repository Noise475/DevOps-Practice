# modules/ou_creation/variables.tf

variable "ou_names" {
  description = "List of OU names to create"
  type        = list(object({ name = string }))
  default     = [{ name = "dev" }, { name = "staging" }, { name = "prod" }]
}

variable "parent_ou_id" {
  description = "ID of the parent OU (optional)"
  type        = string
  default     = "null"
}
