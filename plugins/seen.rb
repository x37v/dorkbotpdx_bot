#taken from:
#https://github.com/cinchrb/cinch/blob/master/examples/plugins/seen.rb
#76d3bfd0ca56e9b5ba52da2c946f54117050958e
class Seen
  class SeenStruct < Struct.new(:who, :where, :what, :time)
    def to_s
      "[#{time.asctime}] #{who} was seen in #{where} saying #{what}"
    end
  end

  include Cinch::Plugin
  listen_to :channel
  match /seen (.+)/

  def initialize(*args)
    super
    @users = {}
  end

  def listen(m)
    @users[m.user.nick] = SeenStruct.new(m.user, m.channel, m.message, Time.now)
  end

  def execute(m, nick)
    if nick == @bot.nick
      m.reply "That's me!"
    elsif nick == m.user.nick
      m.reply "That's you!"
    elsif @users.key?(nick)
      m.reply @users[nick].to_s
    else
      m.reply "I haven't seen #{nick}"
    end
  end
end
