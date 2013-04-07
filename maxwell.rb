#this is where the bot is created and small customizations are made

require File.join(File.dirname(__FILE__), 'bot')

opts = {
  :server => 'irc.freenode.org',
  :channels => ['#dorkbotpdx'],
  :name => 'maxwell-dbpdx'
}

bot = create_bot(opts)

#check out bot.rb for 'helpers' that you can use

#will execute the block given when a 'message' with prefix '!repo' is sent
#the next string is put into the help system for this command
bot.on_with_help :message, 'repo', 'Gives information about how to extend/enhance my programming' do |m|
  response = Format("Add to or modify me: %s" % [urlize("https://github.com/x37v/dorkbotpdx_bot")])
  m.reply(response)
end

#responds to !paul or !teensy or !pjrc
bot.on_with_help :message, '(paul|teensy|pjrc)', 'Gives information about Paul/Teensy/pjrc' do |m|
  response = Format("Paul [teensy]'s website is %s and he can be reached at %s" % [urlize("https://www.pjrc.com"), Format(:yellow, "paul@pjrc.com")])
  m.reply(response)
end

bot.on_with_help :message, '(laen|osh|pcb)', 'Gives information Laen and #oshcpark PCB orders' do |m|
  response = Format("Laen's PCB order has its own channel, %s and the website is %s" % [Format(:yellow, "#oshpark"), urlize("http://oshpark.com")])
  m.reply(response)
end

bot.on_with_help :message, 'faq', 'Provides a link to the FAQ (frequently asked questions)' do |m|
  response = Format("DorkbotPDX FAQ lives here: %s" % [urlize("http://dorkbotpdx.org/wiki/frequently_asked_questions")])
  m.reply(response)
end

bot.on_with_help :message, 'meet', 'Describes when we meet and links to the meeting page' do |m|
  response = Format("Meetings are every other Monday, 7pm, at Backspace: %s" % [urlize("http://dorkbotpdx.org/meetings")])
  m.reply(response)
end

bot.start
