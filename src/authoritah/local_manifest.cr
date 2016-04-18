module Authoritah
  class LocalManifest
    getter :rules

    def initialize(filename : String = "./rules.yml")
      @rules = Array(RuleConfig).from_yaml File.read(filename)
    end

    def initialize(file : IO)
      @rules = Array(RuleConfig).from_yaml file.gets_to_end
    end

    def ids
      rules.map &.id
    end

    def find(id : String)
      rules.find { |r| r.id == id }
    end

    def find(rule : Rule)
      find(rule.id)
    end

    def diff(others : ServerManifest)
      removed = others.ids - ids

      diffs = rules.map do |rule|
        other = others.find(rule)
        Diff.new(rule, other, rule)
      end.reject &.empty?

      # add in removals
      diffs.concat others.find(removed).map { |other| Diff.new(nil, other, other) }
    end
  end
end
