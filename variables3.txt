####################

variable "environment" {
    type = string
}
variable "resource_group" {
   type = object({
   name          = string
   location      = string
  })	  
  
}

#################################################################
#tfvar file
#"environment" : "DEV"
#"resource_group" : {
#  "name" : "ri-d-inc-inp-spc-rg"
#  "location" : "Central us"
#},