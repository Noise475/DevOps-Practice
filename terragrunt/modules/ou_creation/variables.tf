# modules/ou_creation/variables.tf

variable "ou_names" {
  description = "List of OU names to create"
  type        = list(string)
}

variable "parent_ou_id" {
  description = "ID of the parent OU (optional)"
  type        = string
  default     = null
}

variable "ou" {
  description = "variable holding current orginazation"
  type = string
}
