locals {
  name = "zaki"
}


resource "local_file" "myfile" {
  filename = "${local.name}.txt"
  content = "My name is ${local.name}"
}
