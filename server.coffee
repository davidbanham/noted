http = require 'http'
fs = require 'fs'
path = require 'path'

handler = (req, res) ->
  if ['favicon.ico'].indexOf(path.basename(req.url)) > -1
    res.writeHead 404
    return res.end()
  if req.url is '/' then return serveIndex 'html', req, res
  if req.url is '/index.js' then return serveIndex 'js', req, res
  req.url.replace /\./g, ''
  if req.method is 'PUT' then return savePage req, res
  if req.method is 'GET' then return servePage req, res

serveIndex = (ext, req, res) ->
  fs.createReadStream("./index.#{ext}").pipe(res)

servePage = (req, res) ->
  reader = fs.createReadStream('notes/' + path.basename(req.url))
  reader.on 'error', (err) ->
    res.end ""
  reader.pipe(res)

savePage = (req, res) ->
  req.pipe(fs.createWriteStream('notes/' + path.basename(req.url))).on 'close', ->
    res.end()

http.createServer(handler).listen(process.env.PORT or 3000)
