# Create a new load balancer
resource "aws_elb" "elb-web" {
  name               = "elb-web"
  availability_zones = ["eu-central-1b"]
  security_groups = ["sg-0bab7953543f29ecc"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 10
  }

  instances                   = ["${aws_instance.client.0.id}", "${aws_instance.client.1.id}"]
  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    Name = "my-test-elb"
  }
}
