class Houston.TestingReport.TestingReportView extends Backbone.View

  initialize: ->
    @tickets = @options.tickets
    @projectsCanCloseTicketsFor = @options.projectsCanCloseTicketsFor
    @tickets.bind 'reset', _.bind(@render, @)
    @expander = new TableRowExpander()

    # Prevent tablesorter from exhuming buried rows
    @tickets.bind 'destroy', (ticket)=>
      $('table.testing-report-table').trigger('update')

    @openTickets = @options.openTickets
    @$addTicket = $("#add_ticket")
    @renderTypeahead() if @$addTicket.length > 0

    $(document).bind 'ticket:create', (e, ticket) =>
      @openTickets.push(ticket)

    @render()

  render: ->
    @$el.empty()
    views = @tickets.map (ticket)=>
      view = new Houston.TestingReport.TestingTicketView
        ticket: ticket
        canClose: _.include(@projectsCanCloseTicketsFor, ticket.get('projectId'))
      @$el.appendView view
      view

    @expander.setupForViews views

    $("[data-tester-id=#{window.userId}]").addClass('current-tester') if window.userId

    $('table.testing-report-table').tablesorter
      headers: {'4': {sorter: 'text'}}

  renderTypeahead: ->
    typeaheadTemplate = HandlebarsTemplates['tickets/typeahead']
    view = @
    @$addTicket.attr('autocomplete', 'off').typeahead
      source: -> _.reject(view.openTickets, (ticket) -> ticket.id in view.tickets.pluck("id"))
      matcher: (item)->
        ~item.summary.toLowerCase().indexOf(@query.toLowerCase()) ||
        ~item.projectTitle.toLowerCase().indexOf(@query.toLowerCase()) ||
        ~item.number.toString().toLowerCase().indexOf(@query.toLowerCase())

      sorter: (items)->
        view.suggestions = items
        view.$el.toggleClass('no-suggestions', items.length is 0)
        items # apply no sorting (return them in order of priority)

      highlighter: (ticket)->
        query = @query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&')
        regex = new RegExp("(#{query})", 'ig')
        ticket.summary.replace regex, ($1, match)-> "<strong>#{match}</strong>"
        typeaheadTemplate
          summary: ticket.summary.replace regex, ($1, match)-> "<strong>#{match}</strong>"
          number: ticket.number.toString().replace regex, ($1, match)-> "<strong>#{match}</strong>"

    @$addTicket.data('typeahead').render = (tickets)->
      items = $(tickets).map (i, item)=>
        i = $(@options.item).attr('data-value', item.id)
        i.find('a').html(@highlighter(item))
        i[0]

      items.first().addClass('active')
      @$menu.html(items)
      @

    @$addTicket.data('typeahead').select = ->
      @hide()

      id = @$menu.find('.active').attr('data-value')
      ticket = _.detect view.openTickets, (ticket)-> +ticket.id == +id
      view.$addTicket.val("")
      view.addTicket ticket

  addTicket: (ticket)->
    $(".testing-report-add-ticket").addClass("working")
    $.post "/testing_report", ticket_id: ticket.id
      .success (ticket)=>
        $(".testing-report-add-ticket").removeClass("working")
        @tickets.add ticket
        @render()
      .error =>
        $(".testing-report-add-ticket").removeClass("working")
        alertify.error "Sorry. An error occurred when I tried to add that ticket to the Testing Report"
