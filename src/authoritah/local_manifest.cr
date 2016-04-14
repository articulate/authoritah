module Authoritah
  class LocalManifest
    property :rules

    def self.new(filename : String = "./rules.yml")
      new(File.new(filename))
    end

    def initialize(file : File)
      @rules = Array(RuleConfig).from_yaml file.gets_to_end
    end

    def diff(others : LocalManifest)
      rules.each do |rule|
        other = others.fetch(rule)
        rule.diff(other)
      end
    end
  end
end
