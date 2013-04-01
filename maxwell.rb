#this is where the bot is created and small customizations are made

require File.join(File.dirname(__FILE__), 'bot')

opts = {
	:server => 'irc.freenode.org',
	:channels => ['#dorkbotpdx'],
	:name => 'maxwell-dbpdx'
}

bot = create_bot(opts)

bot.on :message, /^!?help/ do |m|
	if(not m.channel?) # sent with a private message
		m.reply(Format(:red, "-----------------------------------------------------------------"))
		m.reply(Format("I am %s. I am programmed with the following commands:" % [Format(:yellow, "Maxwell")]))
		m.reply(Format(:red, "------------------- public/channel commands ---------------------"))
		reply_cmd(m, 'paul', 'Gives information about Paul/Teensy/pjrc') 
		reply_cmd(m, 'laen', 'Gives information Laen and #oshcpark PCB orders')
		reply_cmd(m, 'faq', 'Provides a link to the FAQ (frequently asked questions)')
		reply_cmd(m, 'meet', 'Describes when we meet and links to the meeting page')
		reply_cmd(m, 'repo', 'Gives information about how to extend/enhance my programming.')
		reply_cmd(m, 'help', 'Tells users how to get help from me.')
		m.reply(Format(:red, "------------------- private/message commands --------------------"))
		m.reply(Format(" %s : That's all we've built so far!" % [Format(:pink, '/msg %s help')]))
	elsif(m.message =~ /^!help/) # asked in the channel
		response = Format("Maxwell at your service. I am here to assist you.  %s" % [Format(:pink, "/msg %s help" % [opts[:name]])])
		m.reply(response)
	end
end

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

def reply_cmd(m, cmd, description)
	return m.reply(Format(" %s : %s" % [Format(:pink, "%-6s" % ['!' + cmd]), description]))
end

def urlize(u)
	return Format(:lime, u)
end

bot.start
