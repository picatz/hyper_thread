module HyperThread
  class Pool
    attr_reader :max
    attr_reader :queue

    def initialize(max: 2)
      @threads = []
      @mutex   = Mutex.new  
      @queue   = Queue.new  
      @max     = max.to_i   
    end

    def threads
      return @threads unless block_given?
      @threads.each do |thread|
        yield thread
      end
    end

    def shutdown
      @shutdown = true
      dead = @threads.map(&:exit)
      @threads -= dead
    end

    def reap
      dead = @threads.reject(&:alive?)
      dead.map(&:kill)
      @threads -= dead
      return true
    end

    def nsync(&block)
      @mutex.synchronize do
        break if @shutdown
        block.call
      end
      return if @shutdown
    end

    def async(forever: false, count: 1, &block)
      raise "Required block syntax" unless block_given?
      count.times do
        if @threads.count == max
          @queue << block
          next
        end
        self << Thread.new do
          if forever
            loop do
              nsync do 
                block.call
              end
            end
          else
            nsync do 
              block.call
            end
          end
        end
      end
      return @queue if @threads.count == max
      @threads
    end

    def todo(forever: false, count: false)
      raise "Required block syntax" unless block_given?
      if count
        count.times do
          yield @queue.pop
        end
      else
        if forever
          loop do  
            while @queue.size > 0
              yield @queue.pop
            end
          end
        else
          yield @queue.pop
        end
      end
    end

    def qsync(count: 1, &block)
      nsync do 
        raise "Required block syntax" unless block_given?
        Thread.new do
          count.times do
            @queue << block
          end
        end
        true
      end
    end

    def todo?
      nsync do 
        return true if @queue.size > 0
        false
      end
    end

    def <<(thread)
      nsync do
        return false if @threads.count == max
        @threads << thread
      end
    end

  end

end
