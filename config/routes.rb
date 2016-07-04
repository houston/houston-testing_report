Houston::TestingReport::Engine.routes.draw do

  get "testing_report" => "testing_report#index", :as => :testing_report
  get "testing_report/:slug" => "testing_report#show", :as => :project_testing_report

  scope "tickets/:ticket_id" do
    resources :testing_notes
  end

end
