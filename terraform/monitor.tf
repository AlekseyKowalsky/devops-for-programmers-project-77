resource "datadog_synthetics_test" "web_servers_health_check" {
  name = "Web Server Health Check"
  type = "api"
  subtype = "multi"
  status  = "live"
  message = "Alert! One of the web servers seems down. Notify: @pagerduty"
  tags    = ["host:tfhexlet-1", "host:tfhexlet-2"]
  locations = ["aws:eu-central-1"]

  api_step {
    name    = "Checking web-1 health"
    subtype = "http"

    assertion {
      type     = "statusCode"
      operator = "is"
      target   = "200"
    }

    request_definition {
      method = "GET"
      url =  "http://${digitalocean_droplet.web-1.ipv4_address}"
      port = var.app_port
      timeout = 30
    }
  }

  api_step {
    name    = "Checking web-2 health"
    subtype = "http"

    assertion {
      type     = "statusCode"
      operator = "is"
      target   = "200"
    }

    request_definition {
      method = "GET"
      url = "http://${digitalocean_droplet.web-2.ipv4_address}"
      port = var.app_port
      timeout = 30
    }
  }

  options_list {
    tick_every = 60
  }
}