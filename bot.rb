# encoding: UTF-8 
#load up the plugin files, and on create_bot(options) create a bot with the
#specified plugins and automatic url shortening

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

class PreMeet
	def initialize(bot)
	  @where = 'SlowBar'
	  @who = []
	  @whonot = []
	  @bot = bot
	end

	def handle(m)
	  clear() unless today_is_dorkbot()
      if m.message =~ /^!slow$/
	    ask_status(m)
      elsif m.message =~ /^!slow\?$/
	    about_slow(m)
	  elsif m.message =~ /^slow\+\+/
	    add_nick(m)
	  elsif m.message =~ /^slow--$/
	    remove_nick(m)
	  else
	    return false
	  end
	  return true
	end

	def add_nick(m)
	  if today_is_dorkbot()
        @whonot.delete(m.user.nick)
	    if @who.include?(m.user.nick)
  		  m.reply(@bot.Format(:yellow, '%s: Settle down, we know you\'ll be there.' % [m.user.nick]))
	    else
		  @who = (@who << m.user.nick).uniq
		  m.reply(@bot.Format(:lime, '%s will be going to the premeet at %s' % [m.user.nick, @where]))
	    end
		ask_status(m)
	  else
	    m.reply(m.user.nick + ': That will make more sense on a Dorkbot day.')
	  end
	end

	def remove_nick(m)
	  if today_is_dorkbot()
        @who.delete(m.user.nick)
		@whonot = (@whonot << m.user.nick).uniq
	    m.reply(m.user.nick + ': You will be missed!')
		ask_status(m)
      else
	    m.reply(m.user.nick + ': That will make more sense on a Dorkbot day.')
	  end
	end

	def ask_status(m)
	  if today_is_dorkbot()
	    if(@who.size == 0)
	      m.reply(@bot.Format(:red, 'Nobody has committed to %s yet today.' % [@where]))
	    else
	      m.reply(@bot.Format(:yellow, '%s premeet attendees: %s' % [@where, @bot.Format(:lime, @who.join(", "))]))
	    end
		if(@whonot.size > 0)
		  m.reply(@bot.Format(:yellow, '%s premeet absentees: %s' % [@where, @bot.Format(:red, @whonot.join(", "))]))
		end
	  else
	    clear()
		about_slow(m)
	  end
	end

	def about_slow(m)
	  response =  @bot.Format(:lime, "Pre-meet is at %s, about 6pm on Dorkbot Monday nights. Join us!" % [@where])
	  m.reply(response)
	end

	def today_is_dorkbot()
	  # Would be rad if this were actually tied into the google calendar!
      # For now it's just a biweek calculation on a known dorkbot date
	  known_dorkbot = Date.parse('2013-10-21')
	  date = Date::today
	  while((date <=> known_dorkbot) >= 0)
	    if(date === known_dorkbot)
		  return true
		end
	    date = date - 14
      end
	  return false
	end

	def clear()
	  @who = []
	  @whonot = []
	end

end

class ResistorCalc
	def initialize(bot)
	  @bot = bot
	end

	def handle(m)
      if m.message =~ /^!res/
		parts = m.message.split(/\s+/)
		if parts[1].downcase =~ /\d(\.\d)?+k/ or parts[1] =~ /\d(\.\d)?m/
		  m.reply(m.user.nick + ": I don't grok that yet. Help me! https://github.com/x37v/dorkbotpdx_bot")
		  return true
		end
		val = ((10 * map_color(parts[1])) + map_color(parts[2])) * (10**map_color(parts[3]))
	    m.reply(m.user.nick + ': --[' + 
		  color_block(parts[1]) + ' ' + 
		  color_block(parts[2]) + ' ' + 
		  color_block(parts[3]) + 
		  ']-- ' + human_readable(val));
		return true
	  end
	end

	def map_color(color)
	  colors = ['black', 'brown', 'red', 'orange', 'yellow', 'green', 'blue', 'violet', 'gray', 'white']
      # gold and silver...meh!
	  return colors.index(normalize_color(color))
	end

	def normalize_color(color)
	  color = color.downcase
	  color = color.gsub(/purple/, 'violet')
	  color = color.gsub(/grey/, 'gray')
	  return color
	end

	def human_readable(value)
	  return @bot.Format(:white, human_readable_text(value))
	end

	def human_readable_text(value)
	  ohm = 'Ω'
	  if value < 1000
	    return value.to_s + ' ' + ohm
	  elsif value < 10000
	    return (value/1000.0).to_s + 'k ' + ohm
	  elsif value < 100000
	    return (value*10/10000.0).to_s + 'k ' + ohm
	  elsif value < 1000000
	    return (value*100/100000.0).to_s + 'k ' + ohm
	  else
	    return (value/1000000.0).to_s + 'M ' + ohm
	  end
	end

	def color_block(color)
	  block = '█'
	  case normalize_color(color)
	  when 'black'
	    colorsym = :black
	  when 'brown'
	    colorsym = :brown
	  when 'red'
	    colorsym = :red
	  when 'orange'
	    colorsym = :orange
	  when 'yellow'
	    colorsym = :yellow
	  when 'green'
	    colorsym = :green
	  when 'blue'
	    colorsym = :blue
	  when 'violet'
	    colorsym = :purple
	  when 'gray'
	    colorsym = :grey
	  when 'white'
	    colorsym = :white
	  end
	  return @bot.Format(colorsym, '%s' % [block])
	end
end

# Automatically shorten URL's found in messages
# Using the tinyURL API

class Cinch::Bot

  def handle_as_premeet(m)
    @premeet ||= PreMeet.new(self)
    return @premeet.handle(m)
  end

  def handle_as_resistor(m)
  	@rescalc ||= ResistorCalc.new(self)
	return @rescalc.handle(m)
  end

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
      message.reply(Format(" %s : Pre-meeting roundup roll call" % [Format(:pink, "%-6s" % ['!slow'])]))
      message.reply(Format(" %s : Calculate a resistor value from a color triplet" % [Format(:pink, "%-6s" % ['!res[istor]'])]))
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
      return if bot.handle_as_premeet(m)
      return if bot.handle_as_resistor(m)
      return if m =~ /\A!/	# The help system will handle it
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

