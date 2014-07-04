# Description:
#   the most useless hubot script
#
# Configuration:
#   HUBOT_YO_API_TOKEN (required. http://yoapi.justyo.co/)
#   HUBOT_YO_NAME (optional)
#   HUBOT_YO_ROOM (optional)
#
# Commands:
#   hubot yo - sends yo to subscribers
#   hubot yo name - replies yo name
#
# Author:
#   sakatam

module.exports = (robot) ->
  token = process.env.HUBOT_YO_API_TOKEN
  name = process.env.HUBOT_YO_NAME
  room = process.env.HUBOT_YO_ROOM

  robot.logger.error "HUBOT_YO_API_TOKEN is not set" unless token?
  robot.logger.error "HUBOT_YO_NAME is not set" unless name?
  robot.logger.error "HUBOT_YO_ROOM is not set" unless room?

  if token?
    robot.respond /yo(all)?$/, (msg) ->
      http = robot.http("http://api.justyo.co").path("yoall/")
      # XXX: robot.http() doesn't take option - https://github.com/github/hubot/pull/612
      http.options.headers["Content-Type"] = "application/x-www-form-urlencoded"
      http.post("api_token=#{token}") (err, res, body) ->
        msg.reply "sent Yo to all subscribers" unless err

  if name?
    robot.respond /yo name/, (msg) ->
      msg.reply "my yo name is #{name}"

  if room?
    robot.router.get "/yo", (req, res) ->
      robot.messageRoom room, "received Yo from #{req.params.username}"
