variable "project_name" {
  description = "The project name"
  type        = string
  default     = "peon-media-hosting"
}

variable "region_shorthand" {
  description = "The shorthand name of the region"
  type        = string
  default     = "use1"
}

# S3
###############################################################################
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "peon-media"
}

# CloudFront
###############################################################################
variable "cloudfront_key_group_id" {
  description = "The ID of the CloudFront key group"
  type        = string
}