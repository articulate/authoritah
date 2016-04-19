module Authoritah
  class LocalManifest
    getter :rules

    def initialize(filename : String = "./rules.yml")
      @rules = Array(RuleConfig).from_yaml File.read(filename)
    end

    def initialize(file : IO)
      @rules = Array(RuleConfig).from_yaml file.gets_to_end
    end

    def uuids
      rules.map &.uuid
    end

    # Will not return ConfigRule with id
    def find(uuid : String)
      rules.find { |r| r.uuid == uuid }
    end

    def find(rule : Rule)
      cfg = find(rule.uuid)
      cfg.id = rule

      cfg
    end

    def diff(others : ServerManifest)
      removed = others.uuids - uuids

      diffs = rules.map do |rule|
        other = others.find(rule)
        Diff.new(rule, other, rule)
      end.reject &.empty?

      # add in removals
      diffs.concat others.find(removed).map { |other| Diff.new(nil, other, other) }
    end
  end
end
