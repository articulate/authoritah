require "./spec_helper"

module Authoritah
  describe Rule do
    model = rule_fixture("rule")

    it "can be built from JSON" do
      model.should be_a(Rule)
      model.name.should eq "derp rule"
    end

    context "script" do
      file1 = "./spec/fixtures/#{model.name}.js"
      file2 = "./rules/#{model.name}.js"

      it "can be saved" do
        File.exists?(file1).should be_false

        model.save_script "./spec/fixtures"
        File.exists?(file1).should be_true
      end

      it "defaults save to ./rules/<name>.js" do
        File.exists?(file2).should be_false

        model.save_script
        File.exists?(file2).should be_true
      end

      # cleanup
      File.delete file1
      File.delete file2
      Dir.rmdir "./rules"
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
