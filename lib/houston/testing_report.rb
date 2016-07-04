require "houston/testing_report/engine"
require "houston/testing_report/configuration"

module Houston
  module TestingReport
    extend self

    def config(&block)
      @configuration ||= TestingReport::Configuration.new
      @configuration.instance_eval(&block) if block_given?
      @configuration
    end

  end
end
