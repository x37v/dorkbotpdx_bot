#this is where the bot is created and small customizations are made

require File.join(File.dirname(__FILE__), 'bot')

opts = {
	:server => 'irc.freenode.org',
	:channels => ['#bxtest'],
	:name => 'bxtest'
}

bot = create_bot(opts)

urls_color = :lime

bot.on :message, /^!(paul|teensy|pjrc)/ do |m|
	response = Format("Paul [teensy]'s website is %s and he can be reached at %s" % [Format(urls_color, "https://www.pjrc.com"), Format(:yellow, "paul@pjrc.com")])
	m.reply(response)
end

bot.on :message, /^!(laen|osh|pcb)/ do |m|
	response = Format("Laen's PCB order has its own channel, %s and the website is %s" % [Format(:yellow, "#oshpark"), Format(urls_color, "http://oshpark.com")])
	m.reply(response)
end

bot.on :message, /^!repo/ do |m|
	response = Format("Add to or modify me: %s" % [Format(:urls_color, "https://github.com/x37v/dorkbotpdx_bot")])
	m.reply(response)
end

bot.on :message, /^!faq/ do |m|
	response = Format("DorkbotPDX FAQ lives here: %s" % [Format(:urls_color, "http://dorkbotpdx.org/wiki/frequently_asked_questions")])
	m.reply(response)
end

bot.on :message, /^!meet/ do |m|
	m.reply("Meetings are every other Monday, 7pm, at Backspace:  http://dorkbotpdx.org/meetings")
end

bot.start
