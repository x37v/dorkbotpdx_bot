require File.join(File.dirname(__FILE__), 'bot')

opts = {
	:server => 'irc.freenode.org',
	:channels => ['#dorkbotpdx'],
	:name => 'maxwell-dbpdx'
}

bot = create_bot(opts)

bot.on :message, /^!paul/ do |m|
	m.reply("Paul [teensy]'s website is https://www.pjrc.com/ and he can be reached at paul@pjrc.com")
end

bot.on :message, /^!laen/ do |m|
	m.reply("Laen's PCB order has its own channel, #oshpark and the website is http://oshpark.com/")
end

bot.on :message, /^!repo/ do |m|
	m.reply("add/modify me:  https://github.com/x37v/dorkbotpdx_bot")
end

bot.start
