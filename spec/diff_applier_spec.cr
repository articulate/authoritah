require "./spec_helper"

module Authoritah
  describe DiffApplier do
    diffs = [
      Diff.new("yes", "no"),
      Diff.new(nil, "no"),
      Diff.new("no", nil),
    ]

    applier = DiffApplier.new(diffs, FakeClient.new)

    it "applies all the diffs properly" do
      applier.apply.should eq ["no", "okay", "yes"]
    end
  end
end
