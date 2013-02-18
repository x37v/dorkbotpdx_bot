#taken from
#https://github.com/cinchrb/cinch/blob/master/examples/plugins/memo.rb
#76d3bfd0ca56e9b5ba52da2c946f54117050958e
class Memo
  class MemoStruct < Struct.new(:nick, :channel, :text, :time)
    def to_s
      "[#{time.asctime}] <#{channel}/#{nick}> #{text}"
    end
  end

  include Cinch::Plugin

  listen_to :message
  match /memo (.+?) (.+)/

  def initialize(*args)
    super
    @memos = {}
  end

  def listen(m)
    if @memos.has_key?(m.user.nick)
      m.user.send @memos.delete(m.user.nick).to_s
    end
  end

  def execute(m, nick, message)
    if @memos.key?(nick)
      m.reply "There's already a memo for #{nick}. You can only store one right now"
    elsif nick == m.user.nick
      m.reply "You can't leave memos for yourself.."
    elsif nick == bot.nick
      m.reply "You can't leave memos for me.."
    else
      @memos[nick] = MemoStruct.new(m.user.nick, m.channel, message, Time.now)
      m.reply "Added memo for #{nick}"
    end
  end
end

