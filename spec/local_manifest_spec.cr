require "./spec_helper"

module Authoritah
  describe LocalManifest do
    manifest = LocalManifest.new("./spec/fixtures/rules.yml")

    it "can load a config file" do
      manifest.rules.size.should eq 3
    end

    it "can init from a file" do
      manifest = LocalManifest.new(File.new("./spec/fixtures/rules.yml"))
      manifest.rules.size.should eq 3
    end
  end
end
