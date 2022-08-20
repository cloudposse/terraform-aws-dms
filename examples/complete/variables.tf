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

variable "create_dms_iam_roles" {
  type        = bool
  description = "Flag to enable/disable the provisioning of the required DMS IAM roles. The roles should be provisioned only once per account. See https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.html for more details"
  default     = true
}
