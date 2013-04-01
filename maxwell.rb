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
	response = Format("Paul [teensy]'s website is %s and he can be reached at %s" % [urlize("https://www.pjrc.com"), Format(:yellow, "paul@pjrc.com")])
	m.reply(response)
end

bot.on :message, /^!(laen|osh|pcb)/ do |m|
	response = Format("Laen's PCB order has its own channel, %s and the website is %s" % [Format(:yellow, "#oshpark"), urlize("http://oshpark.com")])
	m.reply(response)
end

bot.on :message, /^!repo/ do |m|
	response = Format("Add to or modify me: %s" % [urlize("https://github.com/x37v/dorkbotpdx_bot")])
	m.reply(response)
end

bot.on :message, /^!faq/ do |m|
	response = Format("DorkbotPDX FAQ lives here: %s" % [urlize("http://dorkbotpdx.org/wiki/frequently_asked_questions")])
	m.reply(response)
end

bot.on :message, /^!meet/ do |m|
	response = Format("Meetings are every other Monday, 7pm, at Backspace:  %s" % [urlize("http://dorkbotpdx.org/meetings")])
	m.reply(response)
end

def urlize(u)
	return Format(:urls_color, u)
end

bot.start
