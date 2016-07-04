class Houston.TestingReport.Ticket extends @Ticket

  testingNotes: ->
    @testingNotesCollection ||= new Houston.TestingReport.TestingNotes(@get('testingNotes'), ticket: @)

  activityStream: ->
    _.sortBy @testingNotes().models.concat(@commits().models), (item)-> item.get('createdAt')

  testerVerdicts: ->
    verdictsByTester = @verdictsByTester(@testingNotesSinceLastRelease())
    window.testers.map (tester)->
      testerId: tester.id
      email: tester.get('email')
      verdict: verdictsByTester[tester.get('id')] ? 'pending'

  verdict: ->
    verdicts = _.values(@verdictsByTester(@testingNotesSinceLastRelease()))
    return 'Failing' if _.include verdicts, 'failing'
    return 'Pending' if window.testers.length == 0

    minPassingVerdicts = @get('minPassingVerdicts') ? window.testers.length
    passingVerdicts = _.filter(verdicts, (verdict)=> verdict == 'passing').length
    return 'Passing' if passingVerdicts >= minPassingVerdicts

    'Pending'

  verdictsByTester: (notes)->
    verdictsByTester = {}
    notes.each (note)->
      testerId = note.get('userId')
      verdict = note.get('verdict')
      if verdict == 'fails'
        verdictsByTester[testerId] = 'failing'
      else if verdict == 'works'
        verdictsByTester[testerId] ?= 'passing'
      else if verdict == 'badticket'
        verdictsByTester[testerId] ?= 'badticket'
      else if verdict == 'none'
        verdictsByTester[testerId] ?= 'comment'
    verdictsByTester

  testingNotesSinceLastRelease: ->
    date = @get('lastReleaseAt')
    if date then @testingNotes().since(date) else @testingNotes()



class Houston.TestingReport.Tickets extends @Tickets
  model: Houston.TestingReport.Ticket
