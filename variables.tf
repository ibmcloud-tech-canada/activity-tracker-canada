# Uncomment this and the corresponding block in version.tf if you want to pass the apikey as a variable
# instead of using an environment variable.
# variable "ibmcloud_api_key" {
#     description = "API Key with authorization to create the resources in this script"
#     type        = string
#     sensitive   = true
# }

variable "resource_group_name" {
  description = "Name of resource group into which you will provision Activity Tracker"
  type        = string
}

variable "activity_tracker_plan" {
  description = "Plan for Activity tracker, 7-day or 30-day"
  type        = string
  default     = "7-day"
}
