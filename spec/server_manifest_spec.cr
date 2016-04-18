require "./spec_helper"

module Authoritah
  describe ServerManifest do
    fake_client = FakeClient.new
    rules = fake_client.fetch_all

    manifest = ServerManifest.new(fake_client)

    it "can load a config file" do
      manifest.rules.size.should eq 4
    end

    it "can find by id" do
      manifest.find("rul_gitP2ivZ7ZV9uDcN").should eq rules.first
    end

    it "can find by config" do
      config = config_fixture("rule")
      manifest.find(config).should eq rules.first
    end
  end
end
