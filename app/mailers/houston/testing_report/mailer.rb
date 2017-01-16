module Houston
  module TestingReport
    class Mailer < ViewMailer

      helper TicketHelper

      def testing_note(testing_note, recipients)
        @note = testing_note
        @tester = testing_note.user
        @ticket = testing_note.ticket
        @project = testing_note.project
        @verdict = testing_note.verdict

        case @verdict
        when "fails"
          @verb = "failed"
          @noun = "Failing Verdict"
        when "none"
          @verb = "commented on"
          @noun = "Comment"
        when "works"
          @verb = "passed"
          @noun = "Passing Verdict"
        else
          Rails.logger.warn "[project_notification] Unhandled TestingNote verdict: #{@verdict.inspect}"
          return
        end

        mail({
          from:     @tester,
          to:       recipients - [@tester],
          subject:  "#{@project.name}: #{@tester.name} #{@verb} ticket ##{@ticket.number}",
          template: "houston/testing_report/mailer/testing_note"
        })
      end

    end
  end
end
