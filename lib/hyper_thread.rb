require 'thread'
require "hyper_thread/version"
require "hyper_thread/pool"
require "hyper_thread/thread"

# Some code copyright (c) 2005, Zed Shaw
# Some code Copyright (c) 2011, Evan Phoenix
# Some code Copyright (c) 2015, Simone Margaritelli

# I basically was refactoring the ThreadPool in BetterCap and made this.

module HyperThread

  def self.easter_egg
    require 'lolize/auto'
  rescue
    raise "Please install lolize!\n$ gem install lolize"
  end

  def self.pool
    Pool
  end

  def self.thread
    HThread
  end

end
