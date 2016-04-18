require "./spec_helper"

module Authoritah
  describe Rule do
    model = rule_fixture("rule")

    it "can be built from JSON" do
      model.should be_a(Rule)
      model.name.should eq "derp rule"
    end

    context "script" do
      it "can be saved" do
        path = "./spec/fixtures/save_script.js"

        File.exists?(path).should be_false

        model.save_script path
        File.exists?(path).should be_true

        File.delete path
      end

      it "defaults save to ./rules/<name>.js" do
        path = "./rules/#{model.name}.js"
        File.exists?(path).should be_false

        model.save_script
        File.exists?(path).should be_true

        # cleanup
        File.delete path
        Dir.rmdir "./rules"
      end
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
          name:  Diff.new("derp rule", "Dumb Prevention"),
          stage: Diff.new("test", "fake_resolve"),
        })
      end
    end
  end
end
