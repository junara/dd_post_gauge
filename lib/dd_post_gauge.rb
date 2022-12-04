# frozen_string_literal: true

require "datadog_api_client"
require "dotenv"
require_relative "dd_post_gauge/version"
require_relative "dd_post_gauge/client"
require_relative "dd_post_gauge/cli"
module DdPostGauge
  Dotenv.load

  class Error < StandardError; end
end
