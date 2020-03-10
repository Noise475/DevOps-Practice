# Variable to describe default ports

variable "server_port" {
  description = "The port the server will use for HTTP/TCP requests"
  type = number
  default = 8080
}

# Path to credentials file

variable "creds" {
  default = "~/.aws/credentials"
}

variable "open_cider" {
  description = "All traffic allowed cidr block"
  default = "0.0.0.0/0"
}
