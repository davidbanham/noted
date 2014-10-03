window.srp = ->
  elem = document.getElementById 'content'
  text = elem.innerHTML
  target = findOne text
  text = text.replace /\[\[/g, "<a contenteditable=\"false\" href=\"#{target}\">"
  text = text.replace /\]\]/g, '</a>'
  elem.innerHTML = text

window.onload = ->
  fetch 'Directory'
  document.getElementById('content').onclick = (e) ->
    if e.target.pathname and e.target.innerText.substr(0, 4) isnt 'http'
      e.preventDefault()
      fetch e.target.pathname.substring 1

fetch = (name) ->
  get name, (res) ->
    document.getElementById('content').innerHTML = res
    document.getElementById('title').innerText = name

window.load = ->
  name = document.getElementById('title').innerText
  fetch name

window.save = ->
  name = document.getElementById('title').innerText
  content = document.getElementById('content').innerHTML
  put name, content

get = (name, cb) ->
  req = new XMLHttpRequest()
  req.onload = ->
    cb @responseText
  req.open 'GET', name, true
  req.send()

put = (name, content) ->
  req = new XMLHttpRequest()
  req.open 'PUT', name, true
  req.setRequestHeader 'Content-Type', 'text/html'
  req.send(content)

findOne = (text) ->
  text.substring (text.indexOf('[[') + 2), text.indexOf(']]')
