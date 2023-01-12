resource "local_file" "myfile" {
  filename = "test.sh"
  content = var.cont
}

