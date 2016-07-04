Houston.add_project_feature :testing do
  name "Testing"
  icon "fa-comments"
  path { |project| Houston::TestingReport::Engine.routes.url_helpers.project_testing_report_path(project) }
end

Houston.add_project_option "testingReport.minPassingVerdicts" do
  name "Min. Passing Verdicts"
  html do |f|
    <<-HTML
    #{f.text_field :"testingReport.minPassingVerdicts", class: "text_field"}
    HTML
  end
end
