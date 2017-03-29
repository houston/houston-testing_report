module Houston
  module TestingReport
    class TestingNotesController < Houston::TestingReport::ApplicationController
      before_action :find_ticket
      before_action :find_testing_note, :only => [:destroy, :update]
      before_action :authenticate_user!, :only => [:create, :update, :destroy]


      def create
        @testing_note = TestingNote.new(params[:testing_note].merge(user: current_user, project: @ticket.project))

        authorize! :create, @testing_note
        @testing_note.save
        render_testing_note
      end


      def update
        authorize! :update, @testing_note

        @testing_note.update_attributes(params[:testing_note])
        render_testing_note
      end


      def destroy
        authorize! :destroy, @testing_note

        @testing_note.destroy
        head 204
      end


    private

      def find_ticket
        @ticket = Ticket.find(params[:ticket_id])
      end

      def find_testing_note
        @testing_note = @ticket.testing_notes.find(params[:id])
      end

      def render_testing_note
        if @testing_note.errors.any?
          render json: @testing_note.errors, :status => :unprocessable_entity
        else
          render json: Houston::TestingReport::TestingNotePresenter.new(@testing_note)
        end
      end

    end
  end
end
