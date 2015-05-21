pkg = require '../../package.json'
ServiceError = require '../exceptions/ServiceError'

module.exports = (router) ->
  router.route '/healthcheck'
    .get (req,res, next) ->
      res.json {status: 'ok'}

  router.route '/error'
    .get (req,res, next) ->
      throw new ServiceError 500, "Erro Message"
