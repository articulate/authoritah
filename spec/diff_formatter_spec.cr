require "./spec_helper"

module Authoritah
  describe DiffFormatter do
    diffs = [
      Diff.new("yes", nil),
      Diff.new(nil, "no"),
      {yes: Diff.new("other", "fake")},
    ]

    it "can format a diff" do
      str = DiffFormatter.new(diffs).format
      str.should eq "\e[32m+yes\n\e[0m\e[31m-no\n\e[0myes:\n\e[33m*  other\n\e[0m"
    end
  end
end
