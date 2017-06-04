require "spec_helper"

RSpec.describe HyperThread do

  it "has a version number" do
    expect(HyperThread::VERSION).not_to be nil
  end

  it "has an easter egg" do
    HyperThread.easter_egg
  end

end
