resource "null_resource" "main" {
  provisioner "local-exec" {
    command = "echo holaMundo"
  }
}