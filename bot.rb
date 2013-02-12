require 'open-uri'
require 'cinch'
[
	'seen',
#	'shady',
	'hello',
	'topic_history',
	'memo',
].each do |p|
	require File.join(File.dirname(__FILE__), p)
end

# Automatically shorten URL's found in messages
# Using the tinyURL API

def create_bot(opts)
	Cinch::Bot.new do
	  configure do |c|
		 c.server = opts[:server]
		 c.channels = opts[:channels]
		 c.nick = opts[:name]
		 #c.plugins.plugins = [Shady, Seen, Hello, TopicHistory, Memo]
		 c.plugins.plugins = [Seen, Hello, TopicHistory, Memo]
	  end

	  helpers do
		 def shorten(url)
			url = open("http://tinyurl.com/api-create.php?url=#{URI.escape(url)}").read
			url == "Error" ? nil : url
		 rescue OpenURI::HTTPError
			nil
		 end
	  end

	  on :channel do |m|
		 return if m =~ /\A!/
		 urls = URI.extract(m.message, "http").reject { |url| url.length < 70 }

		 if urls.any?
			short_urls = urls.map {|url| shorten(url) }.compact

			unless short_urls.empty?
			  m.reply short_urls.join(", ")
			end
		 end
	  end
	end
end
