http = require 'http'
fs = require 'fs'
path = require 'path'
url = require 'url'

noteDir = (process.env.NOTEDIR or 'notes') + '/'
archiveDir = (process.env.ARCHIVEDIR or 'archive') + '/'

console.log 'archiveDir is', archiveDir

parseCookies = (request) ->
  list = {}
  rc = request.headers.cookie
  rc and rc.split(";").forEach((cookie) ->
    parts = cookie.split("=")
    list[parts.shift().trim()] = unescape(parts.join("="))
    return
  )
  list

auth = (cookie) ->
  return true if !process.env.NOTEDPASS
  return true if cookie.notedpass is process.env.NOTEDPASS

handler = (req, res) ->
  req.parsed = url.parse req.url, true
  return serveLogin req, res unless auth parseCookies req
  if ['favicon.ico'].indexOf(path.basename(req.url)) > -1
    res.writeHead 404
    return res.end()
  if req.url is '/' then return serveIndex 'html', req, res
  if req.url is '/index.js' then return serveIndex 'js', req, res
  if req.parsed.pathname is '/search' then return searchAll req, res
  if req.url.split('/')[1] isnt 'api' then return serveIndex 'html', req, res
  req.url.replace /\./g, ''
  req.url.replace /api\//, ''
  if req.method is 'PUT' then return savePage req, res
  if req.method is 'GET' then return servePage req, res

serveIndex = (ext, req, res) ->
  fs.createReadStream("./index.#{ext}").pipe(res)

serveLogin = (req, res) ->
  res.writeHead 403
  fs.createReadStream("./login.html").pipe(res)

servePage = (req, res) ->
  reader = fs.createReadStream(noteDir + path.basename(req.url))
  reader.on 'error', (err) ->
    res.end ""
  reader.pipe(res)

savePage = (req, res) ->
  fileName = path.basename(req.url).toLowerCase()
  stamp = new Date().toISOString()
  fs.mkdir archiveDir + fileName, (err) ->
    if (err)
      res.writeHead 500
      console.error err
    fs.createReadStream(noteDir + fileName).pipe(fs.createWriteStream(path.join(archiveDir + fileName + '/' + stamp))).on 'close', ->
      req.pipe(fs.createWriteStream(noteDir + fileName)).on 'close', ->
        res.end()

searchAll = (req, res) ->
  fs.readdir noteDir, (err, files) ->
    matches = files.filter search req.parsed.query.s
    res.writeHead 404 if matches.length < 1
    res.end JSON.stringify matches if req.headers.accept.match 'application/json'
    fs.readFile 'search.html', (err, content) ->
      return res.end content if matches.length < 1
      res.end content.toString().replace 'no matches', matches.map(templater "<a href=foobar>foobar</a>").join '</p><p>'

search = (term) ->
  return (file) ->
    return true if fs.readFileSync(path.join(noteDir, file)).toString().match(term)
    return false

templater = (template) ->
  return (insert) ->
    template.replace /foobar/g, insert

http.createServer(handler).listen(process.env.PORT or 3000)
