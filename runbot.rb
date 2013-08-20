#!/usr/bin/env ruby
#
#This is where we make the bot into a daemon.
#You could simply execute the maxwell.rb script to run the bot, but this lets
#you run it in the background with start and stop controls.

require 'rubygems'
require 'daemons'
require 'bundler'
Bundler.setup(:default)

Daemons.run('maxwell.rb')
