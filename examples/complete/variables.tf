variable "region" {
  type        = string
  description = "AWS Region"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "admin_user" {
  type        = string
  description = "Username for the master DB user"
}

variable "admin_password" {
  type        = string
  description = "Password for the master DB user"
}

variable "database_name" {
  type        = string
  description = "Database name (default is not to create a database)"
}

variable "database_port" {
  type        = number
  description = "Database port"
}
