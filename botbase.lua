HTTP = require('socket.http')
HTTPS = require('ssl.https')
ssl = require 'ssl'
URL = require('socket.url')
db = (loadfile "./libs/redis.lua")()
serpent = require('serpent')
ltn12 = require ('ltn12')
json = (loadfile "./libs/JSON.lua")()
version = 'v_1.0'
api_token = 'token' -- set token
admin = id --admin


function bot_init(on_reload) 
print('دریافت پیام ها')
api = dofile('methods.lua')
bot = nil
if not bot then
bot = api.getMe()
end
function vtext(value)
  return serpent.block(value, {comment=false})
end
bot = bot.result
bot_base = dofile('bot.lua')
if not on_reload then
api.sendMessage(admin, '`Dont Edit Bot Start`\n'..os.date('*today* : `%A` \n*Date* : `%d %B %Y`\n*Start Time* : `%X`')..' \n*Version* : `'..version..'`', true)
end
last_update = last_update or 0 
is_started = true 
end
on_edit_receive = function(ed) 
if bot_base.edited then
local success, result = pcall(function()
return bot_base.edited(ed)
end)
if not success then
return
end 
end 
end
on_msg_receive = function(msg) 
if bot_base.action then
local success, result = pcall(function()
return bot_base.action(msg)
end)
if not success then
api.sendReply(msg, 'دادش داری اشتباه میزنی', true)
return
end end end
on_cb_receive = function(cb)

if bot_base.query then
local success, result = pcall(function()
return bot_base.query(cb)
end)
if not success then
return
end end end
local function rethink_reply(msg)
msg.reply = msg.reply_to_message
return on_msg_receive(msg)
end
bot_init()
while true do 
local res = api.getUpdates(last_update+1) 
if res then
for i,msg in ipairs(res.result) do 
last_update = msg.update_id
if msg.message then
if msg.message.reply_to_message then
rethink_reply(msg.message)
else
on_msg_receive(msg.message)
end
elseif msg.callback_query then
on_cb_receive(msg.callback_query)
elseif msg.edited_message then
on_edit_receive(msg.edited_message)
end
end
else
print('Connection error :( :( :( :( :( :( :( ')
end
end
print('داداش داری اشتباه میزنی')
