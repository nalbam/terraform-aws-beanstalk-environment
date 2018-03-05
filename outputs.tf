output "name" {
  value = "${aws_elastic_beanstalk_environment.default.name}"
  description = "Name"
}

output "cname" {
  value = "${aws_elastic_beanstalk_environment.default.cname}"
  description = "ELB technical host"
}
