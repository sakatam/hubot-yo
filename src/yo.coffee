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

Yo = require "yo-api"

module.exports = (robot) ->
  token = process.env.HUBOT_YO_API_TOKEN
  name = process.env.HUBOT_YO_NAME
  room = process.env.HUBOT_YO_ROOM

  robot.logger.error "HUBOT_YO_API_TOKEN is not set" unless token?
  robot.logger.error "HUBOT_YO_NAME is not set" unless name?
  robot.logger.error "HUBOT_YO_ROOM is not set" unless room?

  if token?
    yo = new Yo token
    robot.respond /yo(all)?$/, (msg) ->
      yo.yoall (err) ->
        if err?
          robot.logger.error err
          return msg.reply "something went wrong on sending Yo"
        msg.reply "sent Yo to all subscribers"

  if name?
    robot.respond /yo name/, (msg) ->
      msg.reply "my yo name is #{name}"

  if room?
    robot.router.get "/yo", (req, res) ->
      robot.messageRoom room, "received Yo from #{req.query.username}"
      res.end()
