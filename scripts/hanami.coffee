# Description:
#   Show hanami info image>
#
# Commands:
#   hubot hanami me - show hanami image in Ueno Onshi park.

client = require('cheerio-httpcli')

module.exports = (robot) ->
  URL = "http://sakura.yahoo.co.jp/spot/detail/b6fc248708b406ce67f49c31c194d60734970d08/"
  robot.respond /hanami me/i, (msg) ->
    client.fetch(URL, (err, $, res) ->
      if err
        msg.send("error.")
      else
        img_url = $(".statusValue dd img").attr("src")
        place = $(".floatL h1").text()
        msg.send "#{place}の開花状況\n#{img_url}\n\n#{URL}"
    )
