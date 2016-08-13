require "active_support/concern"

module Houston
  module TestingReport
    module TicketExt
      extend ActiveSupport::Concern

      included do
        has_many :testing_notes
      end

      def testing_notes_since_last_release
        last_release_at ? testing_notes.where(["created_at > ?", last_release_at]) : testing_notes
      end

      def participants
        @participants ||= begin              # Participants in a Ticket include:
          User.unretired.where(id:           #
            Array(reporter_id) +             #   - its reporter
            testing_notes.pluck(:user_id) +  #   - anyone who has commented on it
            releases.pluck(:user_id)) +      #   - anyone who has released it
            committers                       #   - anyone who has comitted to it
        end                                  #
      end

      def testers
        @testers ||= (project.team ? project.team.roles.with_role("Tester").to_users.unretired : [])
      end

    end
  end
end
