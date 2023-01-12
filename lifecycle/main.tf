resource "random_integer" "rand_int" {
  min = 1
  max = 20

  lifecycle {
  # create_before_destory = true
  # prevent_destroy = true
  ignore_changes = [
    min,
    max
  ]
  }
}


output "result1" {
  value = random_integer.rand_int.id
}
