# frozen_string_literal: true

require "thor"

module DdPostGauge
  class Cli < Thor
    default_command :call

    desc "version", "Show version"
    def version
      puts DdPostGauge::VERSION
    end

    desc "call", "Call"
    option :metric_name, required: true, type: :string, aliases: "-m", desc: "Metric name"
    option :value, required: true, type: :numeric, aliases: "-v", desc: "Value"
    option :resource_name, type: :string, aliases: "-r", desc: "Resource name"
    option :type_name, type: :string, aliases: "-t", desc: "Type name. Ex. host"
    option :api_key, type: :string, aliases: "-k", desc: "Datadog API key"
    option :site, type: :string, aliases: "-s", desc: "Datadog Site"

    def call
      client = DdPostGauge::Client.new(api_key: options[:api_key], site: options[:site])
      client.call(
        options[:metric_name],
        options[:value],
        resource_name: options[:resource_name],
        type_name: options[:type_name]
      )
    end

    def self.exit_on_failure?
      pp "Exit on failure"
    end
  end
end
