# Description:
#   the most useless hubot script
#
# Configuration:
#   HUBOT_YO_API_TOKEN (required. http://yoapi.justyo.co/)
#   HUBOT_YO_NAME (optional)
#   HUBOT_YO_ROOM (optional)
#
# Commands:
#   hubot yo(all) - sends yo to all subscribers
#   hubot yo {{username}} - yo indivisually
#   hubot yo name - replies yo name
#   hubot yo subs(cribers) - replies total subscribers count
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

  handler = (msg, cb) ->
    (err, res, body) ->
      json = JSON.parse body
      if err? or err or= json.error
        robot.logger.error "something went wrong with yo api", err
        msg?.reply "something went wrong with yo api"
      else
        cb res, json

  if token?
    yo = new Yo token
    robot.respond /yo(all)?$/, (msg) ->
      yo.yoall handler msg, ->
        msg.reply "sent Yo to all subscribers"

    robot.respond /yo ((?!(name|subscribers|subs)$).+)$/, (msg) ->
      username = msg.match[1].toUpperCase()
      yo.yo username, handler msg, ->
        msg.reply "sent Yo to #{username}"

    robot.respond /yo (subscribers|subs)?$/, (msg) ->
      yo.subscribers_count handler msg, (res, json) ->
        msg.reply "I've got #{result} yo subscribers"

  if name?
    robot.respond /yo name$/, (msg) ->
      msg.reply "my yo name is #{name}"

  if room?
    robot.router.get "/yo", (req, res) ->
      robot.messageRoom room, "received Yo from #{req.query.username}"
      res.end()
