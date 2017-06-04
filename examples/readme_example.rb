$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'hyper_thread'

# make a pool of maximum 7 threads
pool = HyperThread.pool.new(max: 10)

# spawn 7 threads, and 3 jobs will be added to the queue
pool.async(count: 10) do
  puts "some work to do"
end

# spool off queued jobs
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

pool.qsync(count: 300) do
  "some work to do #{counter += 1}"
end

# let them manage that queue for roughly 2 seconds
sleep 2

# shutdown the thread pool
puts "Shutting down #{pool.threads.count} threads."
pool.shutdown
