variable "public_key" {
  description = "The public API key for MongoDB Atlas"
  default     = "zaybjirp"
}

variable "private_key" {
  description = "The private API key for MongoDB Atlas"
  default     = "2ad03c90-fd77-457b-ad87-29dc12a81366"
}

variable "atlas_region" {
  default     = "US_EAST_1"
  description = "Atlas Region"
}

variable "aws_region" {
  default     = "us-east-1"
  description = "AWS Region"
}

variable "atlas_dbuser" {
  description = "tech"
}

variable "atlas_dbpassword" {
  description = "qPJ7uBMFNUkRTuP5"
}

variable "aws_account_id" {
  description = "My AWS Account ID"
  default     = "975748149223"
}

variable "atlasorgid" {
  description = "Atlas Org ID"
  default     = "5c98a80fc56c98ef210b8633"
}

variable "atlasprojectid" {
  description = "Atlas Project ID"
  default     = "5c98a80fc56c98ef210b8633"
}

variable "atlas_vpc_cidr" {
  description = "Atlas CIDR"
  default     = "192.168.240.0/21"
}