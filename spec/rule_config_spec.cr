require "./spec_helper"

module Authoritah
  describe RuleConfig do
    config = config_fixture("rule")

    it "can be built from YAML" do
      config.should be_a(RuleConfig)
      config.name.should eq "Dummy Prevention"
    end

    context "comparison" do
      rule = rule_fixture("rule")

      it "can compare with a config" do
        config.should eq rule
      end

      it "shows no differences when equal" do
        config.diff(rule).empty?.should be_true
      end

      it "shows  differences when not different" do
        config_fixture("diff_rule").diff(rule).should eq({
          name:    Diff.new("Dummy Prevention", "Dumb Prevention"),
          enabled: Diff.new(true, false),
          stage:   Diff.new("dummy_resolution", "fake_resolve"),
        })
      end
    end
  end
end
