require "houston/testing_report/engine"
require "houston/testing_report/configuration"

module Houston
  module TestingReport
    extend self

    def dependencies
      [:tickets]
    end

    def config(&block)
      @configuration ||= TestingReport::Configuration.new
      @configuration.instance_eval(&block) if block_given?
      @configuration
    end

  end



  register_events {{
    "testing_note:create" => params("testing_note").desc("A testing note was created"),
    "testing_note:update" => params("testing_note").desc("A testing note was updated"),
    "testing_note:save"   => params("testing_note").desc("A testing note was created or updated"),
  }}

  add_project_feature :testing do
    name "Testing"
    path { |project| Houston::TestingReport::Engine.routes.url_helpers.project_testing_report_path(project) }
  end

  add_project_option "testingReport.minPassingVerdicts" do
    name "Min. Passing Verdicts"
    html do |f|
      <<-HTML
      #{f.text_field :"testingReport.minPassingVerdicts", class: "text_field"}
      HTML
    end
  end

end
