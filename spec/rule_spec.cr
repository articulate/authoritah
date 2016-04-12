require "./spec_helper"

module Cartman
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
    end
  end
end
