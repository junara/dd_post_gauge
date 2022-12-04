# frozen_string_literal: true

module DdPostGauge
  class GaugeBody
    # @param [String] metric_name
    # @param [Integer, Float] value
    # @param [Integer] unix_timestamp
    # @param [String, nil] resource_name
    # @param [String, nil] type_name
    def initialize(metric_name, value, unix_timestamp, resource_name: nil, type_name: nil)
      @metric_name = metric_name
      @value = value
      @unix_timestamp = unix_timestamp
      @resource_name = resource_name
      @type_name = type_name
    end

    def payload
      DatadogAPIClient::V2::MetricPayload.new(
        {
          series: series
        }
      )
    end

    private

    # @return [Array<DatadogAPIClient::V2::MetricSeries>]
    def series
      [
        DatadogAPIClient::V2::MetricSeries.new(
          {
            metric: @metric_name,
            type: type,
            points: points,
            resources: resources
          }
        )
      ]
    end

    # @return [Array<DatadogAPIClient::V2::MetricPoint>]
    def points
      [
        DatadogAPIClient::V2::MetricPoint.new(
          {
            timestamp: @unix_timestamp,
            value: @value
          }
        )
      ]
    end

    # @return [Array<DatadogAPIClient::V2::MetricResource>]
    def resources
      [
        DatadogAPIClient::V2::MetricResource.new(
          {
            name: @resource_name,
            type: @type_name
          }
        )
      ]
    end

    # @return [Object]
    def type
      DatadogAPIClient::V2::MetricIntakeType::GAUGE
    end
  end
end
