# Description:
#   the most useless hubot script
#
# Configuration:
#   HUBOT_YO_API_TOKEN (required. http://yoapi.justyo.co/)
#   HUBOT_YO_ROOM (optional)
#
# Commands:
#   hubot yo - sends yo to subscribers
#
# Author:
#   sakatam

module.exports = (robot) ->
  token = process.env.HUBOT_YO_API_TOKEN
  room = process.env.HUBOT_YO_ROOM

  if token
    robot.respond /// yo(all)?$ ///, (msg) ->
      data = "api_token=#{token}"
      http = robot.http("http://api.justyo.co").path "yoall/"
      # XXX: robot.http() doesn't take option - https://github.com/github/hubot/pull/612
      http.options.headers["Content-Type"] = "application/x-www-form-urlencoded"
      http.post(data) (err, res, body) ->
        msg.reply "sent Yo to all subscribers" unless err

  if room
    robot.router.post "/yo", (req, res) ->
      robot.messageRoom room, "received Yo from #{req.params.username}"
