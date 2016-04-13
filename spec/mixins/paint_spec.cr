require "../spec_helper"

module Authoritah
  describe Mixins::Paint do
    it "will paint strings colors by default" do
      "test".paint(:red).should eq "\e[31mtest\e[0m"
    end

    it "should not color if colorize is disabled" do
      $COLORIZE = false
      "test".paint(:red).should eq "test"
      $COLORIZE = true
    end
  end
end
