variable "subnets_ids" {
  description = "Identifiers of subnets"
  type        = list(any)
}

variable "transit_gateway_id" {
  description = "Transit gateway Id"
  type        = string
}


variable "vpc_id" {
  description = "vpc_id"
  type        = string
}

variable "tags" {
  default = {}
}

variable "attach_name" {
  description = "Attachment Name"
  default     = ""
}