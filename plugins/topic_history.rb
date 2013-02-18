#written by Alex Norman

class TopicHistory
  include Cinch::Plugin
  listen_to :topic, method: :on_topic

  def initialize(*args)
    super
    @topics = Hash.new
  end

  def on_topic(t)
    prev = @topics[t.channel]
    store_topic(t)
    if prev
      t.reply "topic was \"#{prev[0]}\" set by #{prev[1]}"
    end
  end

  def store_topic(t)
    @topics[t.channel] = [t.message, t.user]
  end
end
