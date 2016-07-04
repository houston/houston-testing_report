module Houston
  module TestingReport
    class TestingReportController < ApplicationController
      before_filter :authenticate_user!
      before_filter :find_project, only: [:show]


      def index
        @title = "Testing Report"

        @projects = followed_projects.select { |project| can?(:read, TestingNote.new(project: @project)) }
        @tickets = Ticket.for_projects @projects
      end


      def show
        @title = "Testing Report • #{@project.name}"
        authorize! :show, TestingNote.new(project: @project)

        @projects = [@project]
        @tickets = @project.tickets
      end


    private


      def find_project
        @project = Project.find_by_slug!(params[:slug])
      end


      def default_render
        @tickets = Houston::TestingReport::TicketPresenter.new(@tickets).as_json
        render json: @tickts if request.xhr?
        super
      end


    end
  end
end
