class Shady
	include Cinch::Plugin
	match /shady (.+)/

	def lookup(url, short=false)
		begin
		  req = 'curl --silent "http://www.shadyurl.com/create.php?myUrl=' + url
		  if short
		    req = req + '&shorten=on'
		  end
		  req = req + '"'
		  req = req + ' | awk -F\\\' \'/is now/{print $6}\''
		  IO.popen(req) { |f|
		    resp = f.readlines
			 return resp.first if resp.any?
		  }
		rescue
		end
	end
	def execute(m, url)
		m.reply(lookup(url))
	end
end
