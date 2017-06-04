require 'thread'
require 'pry'
require "hyper_thread/version"
require "hyper_thread/pool"
require "hyper_thread/thread"

module HyperThread

  def self.pool
    Pool
  end

  def self.thread
    HThread
  end

end
