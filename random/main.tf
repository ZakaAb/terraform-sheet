resource "random_integer" "random_int" {
  min = 1
  max = 100
}

output "result1" {
  value = random_integer.random_int.result
}
