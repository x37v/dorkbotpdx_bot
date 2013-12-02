DorkbotPdx bot AKA maxwell
==============

Bot for the #dorkbotpdx irc channel (on freenode)

<a href="http://www.medonis.com/images/Maxwell_looking_sm.jpg"><img src="http://www.medonis.com/images/Maxwell_looking_sm.jpg" alt="maxwell" height="150px"/></a>

Requirements:
---------------------
- ruby (1.9)
- cinch https://github.com/cinchrb/cinch
- daemons http://daemons.rubyforge.org/

Use bundler, edit the Gemfile if you add new gem dependencies.


To run the bot do:
---------------------

foreground:
- `ruby runbot.rb run`

manage the daemon:
- `ruby runbot.rb start`
- `ruby runbot.rb stop`
- `ruby runbot.rb restart`


Contribute:
---------------------

There are a lot of good examples in https://github.com/cinchrb/cinch/tree/master/examples/plugins to start from.

We're just using git to deploy.  Get set up with ssh keys and push master to dorkbotpdx.org:~maxwell/bot/ and the bot should reboot with the new code.
