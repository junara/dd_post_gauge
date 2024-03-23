# frozen_string_literal: true

require "datadog_api_client"
require_relative "gauge_body"

module DdPostGauge
  class Client
    # @param [String] api_key
    # @param [String] site
    def initialize(api_key: nil, site: nil)
      Dotenv.load
      @api_key = api_key || ENV.fetch("DATADOG_API_KEY", nil)
      @site = site || ENV.fetch("DATADOG_SITE", "datadoghq.com")
      configure
    end

    # @param [String] metric_name
    # @param [Integer, Float] value
    # @param [nil, Time] timestamp
    # @param [String, nil] resource_name
    # @param [String, nil] type_name
    # @return [void]
    def call(metric_name, value, timestamp: nil, resource_name: nil, type_name: nil)
      api_instance.submit_metrics(
        body(
          metric_name,
          value,
          unix_timestamp(timestamp),
          resource_name,
          type_name
        )
      )
    end

    private

    # @param [Time, nil] timestamp
    # @return [Integer]
    def unix_timestamp(timestamp)
      if timestamp
        timestamp.to_i
      else
        Time.now.to_i
      end
    end

    def api_instance
      return @api_instance if @api_instance

      @api_instance = DatadogAPIClient::V2::MetricsAPI.new
    end

    # @param [String] metric_name
    # @param [Integer, Float] value
    # @param [Integer] timestamp
    # @param [String, nil] resource_name
    # @param [String, nil] type_name
    # @return [DatadogAPIClient::V2::MetricPayload]
    def body(metric_name, value, timestamp, resource_name, type_name)
      DdPostGauge::GaugeBody.new(
        metric_name,
        value,
        timestamp,
        resource_name: resource_name,
        type_name: type_name
      ).payload
    end

    def configure
      DatadogAPIClient.configure do |config|
        config.server_variables[:site] = @site
        config.api_key = @api_key
      end
    end
  end
end
