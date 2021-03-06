require "./spec_helper"

module Authoritah
  describe LocalManifest do
    manifest = LocalManifest.new("./spec/fixtures/rules.yml")

    it "can load a config file" do
      manifest.rules.size.should eq 5
    end

    it "can init from a file" do
      manifest = LocalManifest.new(File.new("./spec/fixtures/rules.yml"))
      manifest.rules.size.should eq 5
    end

    it "can return all ids" do
      manifest.uuids.should eq [
        "3F1B9C7F-3D43-429A-B6EC-1652E728E061",
        "F4C65760-4306-4871-8172-3A31F00E4723",
        "259C5F5A-F64F-4DA2-86F2-57B395DECBC5",
        "7CED37FE-FBA7-4264-BA37-E92D6F8B1FEC",
        "14043C66-01A6-4408-B476-AB68112A9045",
      ]
    end

    context "diffs" do
      server = ServerManifest.new(FakeClient.new)
      diff = manifest.diff(server)

      it "generates diffs for each actual difference" do
        # all of them change, 2 removes, 3 adds, 1 unmodified, 1 modified
        diff.size.should eq 6
      end

      it "can generate an array of diffs" do
        diff.all? { |d| d.is_a? Diff }.should be_true
      end

      it "knows all types" do
        diff.map(&.state).should eq [:added, :added, :added, :changed, :removed, :removed]
      end
    end
  end
end
