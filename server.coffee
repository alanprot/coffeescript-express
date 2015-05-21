express    = require 'express'
bodyParser = require 'body-parser'
fs = require('fs');
domain = require 'domain';
ServiceError = require './src/exceptions/ServiceError'

app = module.exports = express();

app.use bodyParser.urlencoded {extended: true}
app.use bodyParser.json()

controllerLoader = (router) ->
  load = (file) ->
    if file.indexOf('.coffee') isnt  -1
      console.log file
      controller = require './src/controllers/' + file
      controller(router)

  load f for f in fs.readdirSync './src/controllers'


app.use "/", (err,req,res,next) ->
  requestDomain = domain.create();
  requestDomain.add req;
  requestDomain.add res;
  requestDomain.on 'error', next;
  requestDomain.run next;

router = express.Router();

controllerLoader router

app.use '/', router

app.use (err,req,res,next) ->
  if err instanceof ServiceError
    res.status(err.statusCode)
    res.send err.message;
  else if err instanceof Error
    res.status(500)
    res.send err.message;

