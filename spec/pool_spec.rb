require "spec_helper"

RSpec.describe HyperThread::Pool do
    
  subject(:pool) { HyperThread.pool.new }

  describe ".new" do

    it "can create a new thread pool group" do
      expect(pool).to be_a HyperThread::Pool
    end

    it "will have no threads in the pool" do
      expect(pool.threads.empty?).to be true
    end

    it "will have no jobs queued up" do
      expect(pool.queue.size).to be 0
    end

  end

  describe ".async" do
    
    it "spawns threads to run asynchronously, adding them to the pool" do
      pool.async do
        2 + 5        
      end 
      expect(pool.threads.count).to be 1
    end
    
    it "spawns threads to run asynchronously, optionally running forever in a loop" do
      pool.async(forever: true) do
        2 + 5        
      end 
      expect(pool.threads.map(&:alive?).count).to be 1
    end
    
    it "spawns threads to run asynchronously, optionally providing a count to spawn X ammount of times" do
      pool.async(count: 2) do
        52 - 10
      end 
      expect(pool.threads.count).to be 2
    end

    context "when there are no threads in the pool" do
      after { pool.shutdown }
      
      it "allows threads to be spawned asynchronously, and added to the pool" do
        pool.async do 
          2 + 2
        end
        expect(pool.threads.size).to be 1
      end  

    end

    context "when there are threads in the pool" do
      
      before { pool.async(count: 2) { 3 + 4 } }
      after  { pool.shutdown }

      it "iterate over the threads within the pool when given block syntax" do
        threads = []
        pool.threads do |thread|
          threads << thread
        end
        expect(threads.size).to be 2
      end
      
      it "will queue up jobs that go beyond the maximum number of the pooled threads" do
        pool.async do 
          2 + 2
        end
        expect(pool.queue.size).to be 1
      end

    end

  end

  describe ".threads" do

    it "provides access to the threads within the pool as an array" do
      expect(pool.threads).to be_a Array
    end

    context "when there are threads in the pool" do
      
      before { pool.async(count: 2) { 3 + 4 } }
      after  { pool.shutdown }

      it "iterate over the threads within the pool when given block syntax" do
        threads = []
        pool.threads do |thread|
          threads << thread
        end
        expect(threads.size).to be 2
      end

    end

  end

  describe ".qsync" do

    it "provides a way to add jobs to the job queue" do
      now = pool.queue.size
      more = 1
      expect(pool.queue.size).to be now
      pool.qsync(count: more) do
        2 + 2
      end
      sleep 0.2 # because, non blocking, may need to wait to happen
      expect(pool.queue.size).to eq(now + more)
    end

  end
end
