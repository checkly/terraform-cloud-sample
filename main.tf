variable "checkly_api_key" {}

terraform {
  required_providers {
    checkly = {
      source = "checkly/checkly"
      version = "0.7.1"
    }
  }
}

provider "checkly" {
  api_key = var.checkly_api_key
}

resource "checkly_check" "login" {

  name                      = "Login Flow"
  type                      = "BROWSER"
  activated                 = true
  should_fail               = false
  frequency                 = 10
  double_check              = true
  ssl_check                 = false
  use_global_alert_settings = true
  locations = [
    "us-west-1",
    "eu-central-1"
  ]

  script = file("${path.module}/scripts/login.js")

}

resource "checkly_check" "webstore-list-books" {
  name                      = "list-books"
  type                      = "API"
  activated                 = true
  should_fail               = false
  frequency                 = 1
  double_check              = true
  ssl_check                 = true
  use_global_alert_settings = true

  locations = [
    "eu-central-1",
    "us-west-1"
  ]

  request {
    url              = "https://danube-webshop.herokuapp.com/api/books"
    follow_redirects = true
    assertion {
      source     = "STATUS_CODE"
      comparison = "EQUALS"
      target     = "200"
    }
    assertion {
      source     = "JSON_BODY"
      property   = "$.length"
      comparison = "EQUALS"
      target     = "30"
    }
  }
}