![Hyper Thread Header](https://i.imgur.com/di45BuN.png)

# Hyper Thread

Hyper Thread is simple, flexible thread pool library for Ruby.

## Installation

    $ gem install hyper_thread

## Usage

```ruby
require 'hyper_thread'

# make a pool of maximum 7 threads
pool = HyperThread.pool.new(max: 7)

# spawn 7 threads, and 3 jobs will be added to the queue
pool.async(count: 10) do
  puts "some work to do"
end

# spool off queued jobs outside of thread pool
pool.todo(count: pool.queue.size) do |block|
  block.call # "some work to do"
end

# kill off any dead threads
pool.reap

# queue up 300 jobs
counter = 0

pool.qsync(count: 300) do
  puts "some work to do #{counter += 1}"
end

# spawn 2 threads to manage the queue forever
pool.async(forever: true, count: 2) do
  pool.todo do |block|
    block.call
  end
end

# let them manage that queue for roughly 2 seconds
sleep 2

# shutdown the thread pool
pool.shutdown
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
