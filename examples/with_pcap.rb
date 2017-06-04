$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'hyper_thread'
require 'pcaprub'

cap_pool = HyperThread.pool.new(max: 1)

packets = Queue.new

puts "starting capture"

cap_pool.async do
  cap = PCAPRUB::Pcap.open_live(Pcap.lookupdev, 65535, true, 0)
  loop do
    next unless packet = cap.next
    packets << packet
  end
end

puts "starting parse pool"

parse_pool = HyperThread.pool.new(max: 5)

parse_pool.async(forever: true, count: parse_pool.max) do
  next unless packet = packets.pop
	puts packet.size
end

sleep 2 # let it run for roughly 2 seconds

puts "shutting down capture and parsing pools"
[ cap_pool, parse_pool ].each do |pool|
	pool.shutdown
end

exit 0
