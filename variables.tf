variable "my_instance_type" {
    type=string
    description="my_instance_type"
}

# variable for instance ami id
variable "my_ami_id" {
    type=string
    description = "my_ami_id"
  
}

  
variable "my_bucket_name" {
  type    = map(string)
#   default = {
#     "bucket1" ="terraform-452022"
#     "bucket2" ="terraform-4520222"
#   }
}

# variable "my_bucket_name" {
#   type =tomap(string)
#   default = {
#       bucket1 = "ter_2022"
#       bucket2 = "ter_2023"
#   }
# }
