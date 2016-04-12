require "./spec_helper"

module Cartman
  describe RuleConfig do
    config = config_fixture("rule")

    it "can be built from YAML" do
      config.should be_a(RuleConfig)
      config.name.should eq "Dummy Prevention"
    end

    context "comparison" do
      it "can compare with a config" do
        config.should eq rule_fixture("rule")
      end
    end
  end
end
