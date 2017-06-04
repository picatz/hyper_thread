$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'hyper_thread'

# spawn thread pool
pool = HyperThread.pool.new(max: 7)

# ask to spawn more threads than max value
pool.async(count: 9) do
  "this is some work"
end

# the extra jobs are in a queue
pool.queue.size 
# => 2

# spool off any queue'd jobs outside of pool
pool.todo(count: pool.queue.size) do |block|
  puts block.call 
end

# shutdown pool
pool.shutdown



