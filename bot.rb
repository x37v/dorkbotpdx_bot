#load up the plugin files, and on create_bot(options) create a bot with the
#specified plugins and automatic url shortening

require 'rubygems'
require 'bundler/setup'
require 'open-uri'
require 'cinch'
[
  'seen',
  'hello',
  'topic_history',
  'memo',
].each do |p|
  require File.join(File.dirname(__FILE__), "plugins", p)
end

# Automatically shorten URL's found in messages
# Using the tinyURL API

class Cinch::Bot
  #very basic help system
  def add_help(cmd, help_text)
    @help_data ||= Hash.new
    @help_data[cmd] = help_text
  end

  def on_with_help(event, cmd, help_text, &blk)
    add_help(cmd, help_text)
    self.on(event, /^!#{cmd}/, &blk)
  end

  def print_help(message)
    message.reply(Format(:red, "-----------------------------------------------------------------"))
    message.reply(Format("I am %s. I am programmed with the following commands:" % [Format(:yellow, "Maxwell")]))
    if @help_data
      message.reply(Format(:red, "------------------- public/channel commands ---------------------"))
      @help_data.each do |key, value|
        message.reply(Format(" %s : %s" % [Format(:pink, "%-6s" % ['!' + key]), value]))
      end
      message.reply(Format(:red, "------------------- private/message commands --------------------"))
      message.reply(Format("#{Format(:pink, "/msg #{nick}")} help : That's all we've built so far!"))
    end
  end
end

def create_bot(opts)
  Cinch::Bot.new do
    configure do |c|
      c.server = opts[:server]
      c.channels = opts[:channels]
      c.nick = opts[:name]
      c.plugins.plugins = [Seen, Hello, TopicHistory, Memo]
    end

    helpers do
      def shorten(url)
        url = open("http://tinyurl.com/api-create.php?url=#{URI.escape(url)}").read
        url == "Error" ? nil : url
      rescue OpenURI::HTTPError
        nil
      end

      def reply_cmd(m, cmd, description)
        return m.reply(Format(" %s : %s" % [Format(:pink, "%-6s" % ['!' + cmd]), description]))
      end

      def urlize(u)
        return Format(:lime, u)
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

    #reply to help commands with our help system
    on :message, /^!?help/ do|m|
      if (not m.channel?) # sent with a private message
        bot.print_help(m)
      elsif (m.message =~ /^!help/) # asked in the channel
        response = Format("Maxwell at your service. I am here to assist you.  %s" % [Format(:pink, "/msg %s help" % [bot.nick])])
        m.reply(response)
      end
    end
  end
end


