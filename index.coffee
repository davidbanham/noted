window.srp = ->
  elem = document.getElementById 'content'
  text = elem.innerHTML
  text = replace text
  elem.innerHTML = text
  save()

window.onload = ->
  fetch window.location.pathname.substring('1') or 'Directory'
  document.getElementById('content').onclick = (e) ->
    if e.target.pathname and e.target.textContent.substr(0, 4) isnt 'http'
      e.preventDefault()
      fetch e.target.pathname.substring 1

fetch = (name) ->
  get name, (res) ->
    document.getElementById('content').innerHTML = res || '_'
    document.getElementById('title').textContent = name
    history.pushState({name: name}, name, "/#{name}")

window.onpopstate = (e) ->
  fetch e.state.name

window.load = ->
  name = document.getElementById('title').textContent
  fetch name

window.save = ->
  name = document.getElementById('title').textContent
  content = document.getElementById('content').innerHTML
  put name, content

get = (name, cb) ->
  req = new XMLHttpRequest()
  req.onload = ->
    cb @responseText
  req.open 'GET', 'api/' + name, true
  req.send()

put = (name, content) ->
  req = new XMLHttpRequest()
  req.onload = ->
    error true if req.status isnt 200
    error false if req.status is 200
  req.onerror = ->
    error true
  req.open 'PUT', 'api/' + name, true
  req.setRequestHeader 'Content-Type', 'text/html'
  req.send(content)

error = (state) ->
  return document.body.style.background = 'red' if state
  document.body.style.background = null

findOne = (text) ->
  from = text.indexOf '[['
  return null if from is -1
  text.substring (from + 2), text.indexOf(']]')

replace = (text) ->
  target = findOne text
  return text if !target
  text = text.replace /\[\[/, "<a contenteditable=\"false\" href=\"#{target}\">"
  text = text.replace /\]\]/, '</a>'
  replace text

document.addEventListener 'keydown', (e) ->
  if e.which is 27 #esc
    e.target.blur()
