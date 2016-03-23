# Description:
#   Show hanami info image
#
# Configuration:
#  DEFAULT_HANAMI_PLACE
#
# Commands:
#   hubot hanami list - show place ids
#   hubot hanami me - show hanami image in Default place.
#   hubot hanami <place> - show hanami image in place.

client = require('cheerio-httpcli')

PLACES = [
  { id: "inogashira", value: "4b4d50eef81e7c302b35007f57b7bde70520fc6e" },
  { id: "ueno", value: "b6fc248708b406ce67f49c31c194d60734970d08" }
  { id: "komazawa", value: "e55c6360f4d8259da711c390ae56706b7c9c6820" }
]

module.exports = (robot) ->
  robot.respond /hanami (.+)/i, (msg) ->
    id = msg.match[1]
    url = getUrl(msg, id)
    if id == "list"
      str = ""
      for place in PLACES
        str = "#{str}#{place["id"]} "
      msg.send str
    else
      client.fetch(url, (err, $, res) ->
        if err
          msg.send("error.")
        else
          status = $("li.location span.flower").text()
          place = $(".hdg_inner h1").text()
          msg.send "#{place}\n#{status}\n\n#{url}"
      )

getUrl = (msg, id) ->
  defaultPlace = process.env.DEFAULT_HANAMI_PLACE || "ueno"
  if id == "me"
    value = getPlaceByid(defaultPlace)["value"]
  else
    place = getPlaceByid(id)
    if place != {}
      value = place["value"]
    else
      value = getPlaceByid(defaultPlace)["value"]
  "http://sakura.yahoo.co.jp/spot/detail/#{value}/"

getPlaceByid = (id) ->
  for place in PLACES
    return place if place["id"] == id
  {}
