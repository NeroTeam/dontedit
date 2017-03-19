lang = {
fa = {
['fa'] = 'زبان فارسی انتخاب شد',
['fail'] = 'داری اشتباه میزنی داداچ :|',
['channel'] = 'کانال ما',
['reply'] = 'لطفا ریپلی کنید',
edit = {'ادیت نکن بچه دیدم چی گفتی\n','حالا دور از چشم من ادیت می کنی\nاینم متن ادیت شدت','وای دارم چی میبینم \nادیت نکن دیگه بچه','من این همه مچ گیریمحاله محاله\nمتن قبلیت'},
},
en = {
['en'] = 'bot language seted',
['fail'] = 'input fail',
['channel'] = 'My channel',
['reply'] = 'Please Reply Someone',
edit = {'dont edit pleas\nyour last msg :','it`s your last msg :','please stop editng your last msg','edit is false'},
},
}
function ch(ip)
local keychannel ={}
keychannel.inline_keyboard = {{{text = lang[ip]['channel'],url = 'https://telegram.me/NeroTeam'},}}
return keychannel
end
 local function edited(ed)
 local it = db:hget('lang', ed.chat.id) or 'en'
 local msg_id = ed.message_id
 if ed.text then
 local last_edit = db:hget('lastedit', msg_id)
 if last_edit then
 last_edit_text = db:hget('lastedittext',last_edit) 
 if not last_edit_text then
 return nil
 end
 local text =  db:hget('edit', msg_id) or 'ندیدم چی گفتی دوباره بگو'
  db:hset('edit', msg_id, ed.text)
  local text = last_edit_text..'\n'..lang[it].edit[math.random(#lang[it].edit)]..'\n'..text
 api.editMessageText('edit', last_edit, ed.chat.id, text, keyboard, markdown) 
 db:hset('lastedittext', last_edit,text)
 else
  local text =  db:hget('edit', msg_id) or 'ندیدم چی گفتی دوباره بگو'
  db:hset('edit', msg_id, ed.text)
  local text = lang[it].edit[math.random(#lang[it].edit)]..'\n'..text
local send = api.sendMessage(ed.chat.id, text, true,msg_id, true,nil)
 db:hset('lastedit', msg_id,send.result.message_id)
 db:hset('lastedittext', send.result.message_id,text)
 vardump(send)
end
 end
 end
 local key ={}
 key.inline_keyboard = {
 {
 {text = '🇬🇧ENGLISH🇬🇧',callback_data = 'en'},},
 {
 {text = '🇮🇷فارسی🇮🇷',callback_data = 'fa'},
 }
 }

local function on_msg_receive(msg)
 local ip = db:hget('lang', msg.from.id) or 'en'
 local it = db:hget('lang', msg.chat.id) or 'en'
  if msg.new_chat_member then
  if msg.new_chat_member.id == bot.id then
 return api.sendMessage(msg.chat.id, 'سلام به خودم خوش امد میگم :D', true,msg.message_id, true,ch(ip))
 else
 return 
 end
 end
 if msg.left_chat_member and msg.left_chat_member.id == bot.id then
 return 
 end
 if msg.text:find('/start') then
 if msg.chat['type']:find('private') then
 db:sadd('users',msg.from.id)
 else
 db:sadd('chats',msg.chat.id)
 end
 return api.sendMessage(msg.chat.id, '*Hi Please Select Your Language:* \n----------------\n`سلام لطفا زبان خود را انتخاب کنید:`', true,msg.message_id, true,key)
 end
 if msg.text:find('/show') and msg.reply_to_message then
 if msg.reply_to_message.edit_date then
 msg_id = msg.reply_to_message.message_id
 return api.sendMessage(msg.chat.id, (db:hget('edit', msg_id)or'not fond') , true,msg_id, true,nil)
 else
  return api.sendMessage(msg.chat.id,  lang[it]['reply'], true,msg_id, true,nil)
 end
 end
 if msg.text:find('status') and msg.from.id == admin then
 return api.sendMessage(msg.chat.id,  '*Edit-bot[status]*\nusers : `'..db:scard('users')..'`\nchats : `'..db:scard('chats')..'`', true,msg.message_id, true,nil)
 end
 if msg.text:find('/plan') and msg.from.id == admin then
  local plan ={}
 plan.keyboard = {
 {{text = 'reload🔃'},{text = 'status👥'},},
 {{text = 'Userslist®'},{text = 'chatlist👥'}}
 }
 return api.sendMessage(msg.chat.id, '*admin comands*', true,msg.message_id, true,plan)
 end
 if msg.text:lower():find('userslist') and msg.from.id == admin then
 local mtext = 'List of edit bot users\n'
 for k,v in pairs(db:smembers('users')) do
 mtext = mtext..'\n'..k..'-'..v
 end
 local file = io.open("./users.txt", "w")
    file:write(mtext)
    file:flush()
    file:close()
	local dat = api.sendDocument(msg.chat.id, "./users.txt", msg.message_id) 
	return api.sendMessage(msg.chat.id,'*List of Edit-bot Users*\n*File size : *'..dat.result.document.file_size..'B\n*Power by NeroTeam*', true,dat.result.message_id, true,nil)
 end
  if msg.text:find('chatlist') and msg.from.id == admin then
 local mtext = 'List of edit bot chats\n'
 for k,v in pairs(db:smembers('chats')) do
 mtext = mtext..'\n'..k..'-'..v
 end
 local file = io.open("./chats.txt", "w")
    file:write(mtext)
    file:flush()
    file:close()
	local dat = api.sendDocument(msg.chat.id, "./chats.txt", msg.message_id) 
	return api.sendMessage(msg.chat.id,'`Dont Edit Bot chats:`\n*File size : *'..dat.result.document.file_size..'B\nPower by NeroTeam', true,dat.result.message_id, true,nil)
 end
 if msg.text:find('reload') and msg.from.id == admin then
 bot_init(true)
 return api.sendMessage(msg.chat.id, '`Reloaded`', true,msg.message_id, true,nil)
 end
 if msg.text then
 db:hset('edit', msg.message_id, msg.text)
 if msg.chat.type == 'private' then
 action = 'fail'
 return api.sendMessage(msg.chat.id, lang[ip][action], true,msg.message_id, true,ch(ip))
 end
 end
 end
 function  on_cb_receive(cb)
  local ip = db:hget('lang', cb.from.id) or 'en'
  local it = db:hget('lang', cb.message.chat.id) or 'en'
 if cb.message.chat['type']:find('private') then
 if cb['data'] == 'en' then
  db:hset('lang', cb.from.id, 'en')
 return api.editMessageText('edit', cb.message.message_id, cb.message.chat.id, lang[ip][ip], ch(ip), markdown) 
 elseif cb['data'] == 'fa' then
 db:hset('lang', cb.from.id, 'fa')
 api.editMessageText('edit', cb.message.message_id, cb.message.chat.id, lang[ip][ip], ch(ip), markdown)
 end
 else
 if api.getChatMember(cb.message.chat.id, cb.from.id)['status'] ~= 'member' then
  if cb['data'] == 'en' then
  db:hset('lang', cb.message.chat.id, 'en')
 return api.editMessageText('edit', cb.message.message_id, cb.message.chat.id, lang[it][it], ch(it), markdown) 
 elseif cb['data'] == 'fa' then
 db:hset('lang', cb.message.chat.id, 'fa')
 api.editMessageText('edit', cb.message.message_id, cb.message.chat.id, lang[it][it], ch(it), markdown)
 end
 else
 api.answerCallbackQuery(cb.id, 'شما ادمین نیستید', true) 
 end
 end
 end
 
return {
action = on_msg_receive,
edited = edited,
query = on_cb_receive,
lang = lang
}