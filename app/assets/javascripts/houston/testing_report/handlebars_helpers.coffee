Handlebars.registerHelper 'testerAvatar', (email, size, title)->
  tester = window.testers.findByEmail(email)
  gravatarUrl = "https://www.gravatar.com/avatar/#{MD5(email.toLowerCase().trim())}?r=g&d=retro&s=#{size * 2}"
  "<img src=\"#{gravatarUrl}\" width=\"#{size}\" height=\"#{size}\" rel=\"tooltip\" title=\"#{tester.get('name')}\" />"
