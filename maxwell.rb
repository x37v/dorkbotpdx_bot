#this is where the bot is created and small customizations are made

require File.join(File.dirname(__FILE__), 'bot')

opts = {
	:server => 'irc.freenode.org',
	:channels => ['#dorkbotpdx'],
	:name => 'maxwell-dbpdx'
}

bot = create_bot(opts)

bot.on :message, /^!(paul|teensy)/ do |m|
	m.reply("Paul [teensy]'s website is https://www.pjrc.com/ and he can be reached at paul@pjrc.com")
end

bot.on :message, /^!(laen|osh|pcb)/ do |m|
	m.reply("Laen's PCB order has its own channel, #oshpark and the website is http://oshpark.com/")
end

bot.on :message, /^!repo/ do |m|
	m.reply("Add to or modify me:  https://github.com/x37v/dorkbotpdx_bot")
end

bot.on :message, /^!faq/ do |m|
	m.reply("DorkbotPDX FAQ lives here: http://dorkbotpdx.org/wiki/frequently_asked_questions")
end

bot.on :message, /^!meet/ do |m|
	m.reply("Meetings are every other Monday, 7pm, at Backspace:  http://dorkbotpdx.org/meetings")
end

bot.start
