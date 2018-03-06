# Elastic Beanstalk

resource "aws_s3_bucket_object" "default" {
  source = "${var.bundle}"
  bucket = "${var.bucket}"
  key = "${var.name}/${var.stage}/${var.bundle}"
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name = "${var.version_label}"
  application = "${var.name}"
  bucket = "${aws_s3_bucket_object.default.bucket}"
  key = "${aws_s3_bucket_object.default.key}"
}

#
# Full list of options:
# http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elasticbeanstalkmanagedactionsplatformupdate
#
resource "aws_elastic_beanstalk_environment" "default" {
  name = "${var.name}-${var.stage}"

  application = "${var.name}"

  cname_prefix = "${var.cname_prefix}"

  version_label = "${aws_elastic_beanstalk_application_version.default.name}"

  tier = "${var.tier}"

  solution_stack_name = "${var.solution_stack_name}"

  wait_for_ready_timeout = "${var.wait_for_ready_timeout}"

  # ========== Network ========== #

  setting {
    namespace = "aws:ec2:vpc"
    name = "VPCId"
    value = "${var.vpc_id}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "AssociatePublicIpAddress"
    value = "${var.associate_public_ip_address}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "Subnets"
    value = "${join(",", var.private_subnet_ids)}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "ELBSubnets"
    value = "${join(",", var.public_subnet_ids)}"
  }

  # ========== Autoscaling Update Policy ========== #

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name = "RollingUpdateEnabled"
    value = "true"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name = "RollingUpdateType"
    value = "Health"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name = "MinInstancesInService"
    value = "${var.updating_min_in_service}"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name = "MaxBatchSize"
    value = "${var.updating_max_batch}"
  }

  # ========== Autoscaling Trigger ========== #

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "MeasureName"
    value = "${var.autoscale_trigger}"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name = "Statistic"
    value = "${var.autoscale_statistic}"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name = "Unit"
    value = "${var.autoscale_unit}"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name = "LowerThreshold"
    value = "${var.autoscale_lower_bound}"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name = "UpperThreshold"
    value = "${var.autoscale_upper_bound}"
  }

  # ========== Autoscaling Launch Configuration ========== #

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "SecurityGroups"
    value = "${join(",", var.security_group_ids)}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "InstanceType"
    value = "${var.instance_type}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "${var.iam_instance_profile_name}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "EC2KeyName"
    value = "${var.keypair}"
  }

  # ========== Autoscaling ASG ========== #

  setting {
    namespace = "aws:autoscaling:asg"
    name = "Availability Zones"
    value = "Any"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name = "MinSize"
    value = "${var.autoscale_min}"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name = "MaxSize"
    value = "${var.autoscale_max}"
  }

  setting {
    namespace = "aws:elb:loadbalancer"
    name = "CrossZone"
    value = "true"
  }

  # ========== ELB ========== #

  setting {
    namespace = "aws:elb:listener:80"
    name = "ListenerProtocol"
    value = "HTTP"
  }
  setting {
    namespace = "aws:elb:listener:80"
    name = "InstancePort"
    value = "80"
  }
  setting {
    namespace = "aws:elb:listener:80"
    name = "ListenerEnabled"
    value = "${var.http_listener_enabled}"
  }

  setting {
    namespace = "aws:elb:listener:443"
    name = "ListenerProtocol"
    value = "HTTPS"
  }
  setting {
    namespace = "aws:elb:listener:443"
    name = "InstancePort"
    value = "80"
  }
  setting {
    namespace = "aws:elb:listener:443"
    name = "SSLCertificateId"
    value = "${var.ssl_certificate_arn}"
  }
  setting {
    namespace = "aws:elb:listener:443"
    name = "ListenerEnabled"
    value = "${var.ssl_certificate_arn != "" ? "true" : "false"}"
  }

  //  setting {
  //    namespace = "aws:elb:listener:${var.ssh_listener_port}"
  //    name = "ListenerProtocol"
  //    value = "TCP"
  //  }
  //  setting {
  //    namespace = "aws:elb:listener:${var.ssh_listener_port}"
  //    name = "InstancePort"
  //    value = "22"
  //  }
  //  setting {
  //    namespace = "aws:elb:listener:${var.ssh_listener_port}"
  //    name = "ListenerEnabled"
  //    value = "${var.ssh_listener_enabled}"
  //  }

  setting {
    namespace = "aws:elb:policies"
    name = "ConnectionSettingIdleTimeout"
    value = "60"
  }
  setting {
    namespace = "aws:elb:policies"
    name = "ConnectionDrainingEnabled"
    value = "true"
  }

  # ========== ETC ========== #

  setting {
    namespace = "aws:elasticbeanstalk:application"
    name = "Application Healthcheck URL"
    value = "${var.healthcheck_url}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "LoadBalancerType"
    value = "${var.loadbalancer_type}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "ServiceRole"
    value = "${var.iam_role_service_name}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name = "SystemType"
    value = "enhanced"
  }

  //  // Fixed, Percentage
  //  setting {
  //    namespace = "aws:elasticbeanstalk:command"
  //    name = "BatchSizeType"
  //    value = "Fixed"
  //  }
  //  // 1, 30
  //  setting {
  //    namespace = "aws:elasticbeanstalk:command"
  //    name = "BatchSize"
  //    value = "1"
  //  }
  //  setting {
  //    namespace = "aws:elasticbeanstalk:command"
  //    name = "DeploymentPolicy"
  //    value = "Rolling"
  //  }

  //  // true, false
  //  setting {
  //    namespace = "aws:elasticbeanstalk:managedactions"
  //    name = "ManagedActionsEnabled"
  //    value = "false"
  //  }
  //  // Sun:10:00, ""
  //  setting {
  //    namespace = "aws:elasticbeanstalk:managedactions"
  //    name = "PreferredStartTime"
  //    value = ""
  //  }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name = "InstanceRefreshEnabled"
    value = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name = "UpdateLevel"
    value = "minor"
  }

  # ========== Environment ========== #

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "ENV_NAME"
    value = "${var.name}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "ENV_STAGE"
    value = "${var.stage}"
  }

  //  setting {
  //    namespace = "aws:elasticbeanstalk:application:environment"
  //    name = "CONFIG_SOURCE"
  //    value = "${var.config_source}"
  //  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 0))), 0)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 0))), 0), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 1))), 1)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 1))), 1), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 2))), 2)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 2))), 2), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 3))), 3)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 3))), 3), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 4))), 4)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 4))), 4), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 5))), 5)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 5))), 5), var.env_default_value)}"
  }

  # ========== Notification ========== #

  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name = "Notification Endpoint"
    value = "${var.notification_endpoint}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name = "Notification Protocol"
    value = "${var.notification_protocol}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name = "Notification Topic ARN"
    value = "${var.notification_topic_arn}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name = "Notification Topic Name"
    value = "${var.notification_topic_name}"
  }
}

resource "aws_ssm_activation" "ec2" {
  name = "terraform-${var.name}-${var.stage}-beanstalk-ssm-activation"
  iam_role = "${var.iam_role_ec2_id}"
  registration_limit = "${var.autoscale_max}"
}
