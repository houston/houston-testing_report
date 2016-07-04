require "houston/testing_report/ticket_ext"

module Houston
  module TestingReport
    class Railtie < ::Rails::Railtie

      # The block you pass to this method will run for every request in
      # development mode, but only once in production.
      config.to_prepare do
        ::Ticket.send(:include, Houston::TestingReport::TicketExt)
      end

    end
  end
end
