resource "datadog_synthetics_test" "web_servers_health_check" {
  name      = "Web Server Health Check"
  type      = "api"
  subtype   = "multi"
  status    = "live"
  message   = "Alert! One of the web servers seems down. Notify: @pagerduty"
  tags      = [for i in range(var.droplet_count) : "host:tfhexlet-${i + 1}"]
  locations = ["aws:eu-central-1"]

  dynamic "api_step" {
    for_each = digitalocean_droplet.web
    content {
      name    = "Checking ${api_step.value.name} health"
      subtype = "http"

      assertion {
        type     = "statusCode"
        operator = "is"
        target   = "200"
      }

      request_definition {
        method  = "GET"
        url     = "http://${api_step.value.ipv4_address}"
        port    = var.app_port
        timeout = 30
      }
    }
  }

  options_list {
    tick_every = 60
  }
}