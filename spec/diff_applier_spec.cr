require "./spec_helper"

module Authoritah
  describe DiffApplier do
    diffs = [
      Diff.new("changed", "change", config_fixture("rule")),
      Diff.new(nil, rule_fixture("rule")),
      Diff.new(config_fixture("rule"), nil),
    ]

    applier = DiffApplier.new(diffs, FakeClient.new)

    it "applies all the diffs properly" do
      applier.apply.should eq ["updated", "deleted", "created"]
    end
  end
end
