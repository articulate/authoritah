require "./spec_helper"

module Authoritah
  describe Diff do
    it "knows when equal" do
      diff = Diff.new("yes", "yes")

      diff.added?.should be_false
      diff.removed?.should be_false
      diff.changed?.should be_false
      diff.empty?.should be_true
      diff.state.should eq :equal
    end

    it "knows when adding" do
      diff = Diff.new("yes", nil)

      diff.added?.should be_true
      diff.removed?.should be_false
      diff.changed?.should be_false
      diff.state.should eq :added
    end

    it "knows when removed" do
      diff = Diff.new(nil, "yes")

      diff.added?.should be_false
      diff.removed?.should be_true
      diff.changed?.should be_false
      diff.state.should eq :removed
    end

    it "knows when changed" do
      diff = Diff.new("no", "yes")

      diff.added?.should be_false
      diff.removed?.should be_false
      diff.changed?.should be_true
      diff.state.should eq :changed
    end
  end
end
