require "./spec_helper"

module Authoritah
  describe Rule do
    model = rule_fixture("rule")

    it "can be built from JSON" do
      model.should be_a(Rule)
      model.name.should eq "Dummy Prevention"
    end

    context "comparison" do
      it "can compare with a config" do
        model.should eq config_fixture("rule")
      end

      it "shows no differences when equal" do
        model.diff(config_fixture("rule")).empty?.should be_true
      end

      it "shows  differences when not different" do
        model.diff(config_fixture("diff_rule")).should eq({
          name:    Diff.new("Dummy Prevention", "Dumb Prevention"),
          enabled: Diff.new(true, false),
          stage:   Diff.new("dummy_resolution", "fake_resolve"),
        })
      end
    end
  end
end
