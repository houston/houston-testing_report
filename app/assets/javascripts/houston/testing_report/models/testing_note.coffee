class Houston.TestingReport.TestingNote extends Backbone.Model
  url: ->
    if @isNew()
      "/tickets/#{@get('ticketId')}/testing_notes"
    else
      "/tickets/#{@get('ticketId')}/testing_notes/#{@get('id')}"


class Houston.TestingReport.TestingNotes extends Backbone.Collection
  model: Houston.TestingReport.TestingNote
  url: -> "/tickets/#{@ticket.get('id')}/testing_notes"

  initialize: (models, options)->
    super(models, options)
    @ticket = options.ticket

  since: (date)->
    @filter (note)-> note.get('createdAt') > date
