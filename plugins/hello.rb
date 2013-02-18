#taken from
#https://github.com/cinchrb/cinch/blob/master/examples/plugins/hello.rb
#76d3bfd0ca56e9b5ba52da2c946f54117050958e
class Hello
  include Cinch::Plugin

  match "hello"

  def execute(m)
    m.reply "Hello, #{m.user.nick}"
  end
end

