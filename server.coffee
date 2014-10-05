http = require 'http'
fs = require 'fs'
path = require 'path'

noteDir = (process.env.NOTEDIR or 'notes') + '/'

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
  return true if !process.env.BOBCATPASS
  return true if cookie.bobcatpass is process.env.BOBCATPASS

handler = (req, res) ->
  return serveLogin req, res unless auth parseCookies req
  if ['favicon.ico'].indexOf(path.basename(req.url)) > -1
    res.writeHead 404
    return res.end()
  if req.url is '/' then return serveIndex 'html', req, res
  if req.url is '/index.js' then return serveIndex 'js', req, res
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
  req.pipe(fs.createWriteStream(noteDir + path.basename(req.url))).on 'close', ->
    res.end()

http.createServer(handler).listen(process.env.PORT or 3000)
