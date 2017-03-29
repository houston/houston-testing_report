Handlebars.registerHelper 'testerAvatar', (email, size, title)->
  tester = window.testers.findByEmail(email)
  gravatarUrl = "https://www.gravatar.com/avatar/#{MD5(email.toLowerCase().trim())}?r=g&d=retro&s=#{size * 2}"
  "<img src=\"#{gravatarUrl}\" width=\"#{size}\" height=\"#{size}\" rel=\"tooltip\" title=\"#{tester.get('name')}\" />"

Handlebars.registerHelper 'linkToCommit', (commit)->
  sha = commit.sha[0...8]
  if commit.linkTo
    "<a href=\"#{commit.linkTo}\" target=\"_blank\">#{sha}</a>"
  else
    sha

Handlebars.registerHelper 'radioButton', (object, id, name, value, selectedValue)->
  id = "#{object}_#{id}_#{name}_#{value}"
  input = "<input type=\"radio\" id=\"#{id}\" name=\"#{name}\" value=\"#{value}\""
  input = input + ' checked="checked"' if value == selectedValue
  "#{input} />"
