variable "region" {
  default = "us-east-1"
}

variable "name" {
  default     = "demo"
  description = "A unique name for this Environment."
}

variable "stage" {
  default     = "dev"
  description = "Stage, e.g. 'prod', 'dev', 'stage', or 'test'"
}

variable "cname_prefix" {
  default     = ""
  description = "Prefix to use for the fully qualified DNS name of the Environment."
}

variable "tier" {
  default     = "WebServer"
  description = "Elastic Beanstalk Environment tier, e.g. ('WebServer', 'Worker')"
}

variable "solution_stack_name" {
  //default = "64bit Amazon Linux 2017.09 v2.8.4 running Docker 17.09.1-ce"
  description = "Elastic Beanstalk stack, e.g. Docker, Go, Node, Java, IIS. [Read more](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html)"
}

variable "bundle" {
  //default = ""
  description = "The path to the source file being uploaded to the bucket."
}

variable "bucket" {
  //default = ""
  description = "The name of the bucket to put the file in."
}

variable "version_label" {
  //default = "LatestVersion"
  description = "The name of the Elastic Beanstalk Application Version to use in deployment."
}

variable "wait_for_ready_timeout" {
  default = "20m"
}

variable "vpc_id" {
  //default = ""
  description = "ID of the VPC in which to provision the AWS resources"
}

variable "associate_public_ip_address" {
  default     = "true"
  description = "Specifies whether to launch instances in your VPC with public IP addresses."
}

variable "public_subnet_ids" {
  type = list(string)

  //default = []
  description = "List of public subnets to place Elastic Load Balancer"
}

variable "private_subnet_ids" {
  type = list(string)

  //default = []
  description = "List of private subnets to place EC2 instances"
}

variable "updating_min_in_service" {
  default     = "1"
  description = "Minimum count of instances up during update"
}

variable "updating_max_batch" {
  default     = "1"
  description = "Maximum count of instances up during update"
}

variable "autoscale_trigger" {
  default     = "NetworkOut"
  description = "The measure name associated with the metric the trigger uses. (CPUUtilization, NetworkOut)"
}

variable "autoscale_statistic" {
  default     = "Average"
  description = "The statistic that the trigger uses when fetching metrics statistics to examine."
}

variable "autoscale_unit" {
  default     = "Percent"
  description = "The standard unit that the trigger uses when fetching metric statistics to examine. (Percent, Bytes)"
}

variable "autoscale_lower_bound" {
  default     = "2000000"
  description = "Minimum level of autoscale metric to add instance"
}

variable "autoscale_upper_bound" {
  default     = "6000000"
  description = "Maximum level of autoscale metric to remove instance"
}

variable "security_group_ids" {
  type = list(string)

  //default = []
  description = "List of security groups"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "Instances type"
}

variable "iam_role_service_name" {
  //default = ""
  description = "Instance IAM service role name"
}

variable "iam_instance_profile_name" {
  //default = ""
  description = "Instance IAM instance profile name"
}

variable "keypair" {
  //default = ""
  description = "Name of SSH key that will be deployed on Elastic Beanstalk and DataPipeline instance. The key should be present in AWS"
}

variable "autoscale_min" {
  default     = "1"
  description = "Minumum instances in charge"
}

variable "autoscale_max" {
  default     = "4"
  description = "Maximum instances in charge"
}

variable "http_listener_enabled" {
  default     = "true"
  description = "Enable port 80 (http)"
}

variable "ssl_certificate_arn" {
  default     = ""
  description = "Load Balancer SSL certificate ARN. The certificate must be present in AWS Certificate Manager"
}

//variable "ssh_listener_port" {
//  default = "22"
//  description = "SSH port"
//}

//variable "ssh_listener_enabled" {
//  default = "false"
//  description = "Enable ssh port"
//}

variable "loadbalancer_type" {
  default     = "classic"
  description = "Load Balancer type, e.g. 'application' or 'classic'"
}

variable "healthcheck_url" {
  default     = ""
  description = "Application Health Check URL. Elastic Beanstalk will call this URL to check the health of the application running on EC2 instances"
}

//variable "config_source" {
//  default = ""
//  description = "S3 source for config"
//}

variable "notification_protocol" {
  default     = "email"
  description = "Notification protocol"
}

variable "notification_endpoint" {
  default     = ""
  description = "Notification endpoint"
}

variable "notification_topic_arn" {
  default     = ""
  description = "Notification topic arn"
}

variable "notification_topic_name" {
  default     = ""
  description = "Notification topic name"
}

variable "iam_role_ec2_id" {
  //default = ""
  description = "Instance IAM ec2 role id"
}

variable "env_vars" {
  type        = map(string)
  default     = {}
  description = "Map of custom ENV variables to be provided to the Jenkins application running on Elastic Beanstalk, e.g. `env_vars = { JENKINS_USER = 'admin' JENKINS_PASS = 'xxxxxx' }`"
}

variable "env_default_key" {
  default     = "DEFAULT_ENV_%d"
  description = "Default ENV variable key for Elastic Beanstalk `aws:elasticbeanstalk:application:environment` setting"
}

variable "env_default_value" {
  default     = "EMPTY"
  description = "Default ENV variable value for Elastic Beanstalk `aws:elasticbeanstalk:application:environment` setting"
}
