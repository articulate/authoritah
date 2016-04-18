module Authoritah
  class DiffApplier
    def initialize(@diffs : Array(Diff), @client)
    end

    def apply
      @diffs.map do |diff|
        next @client.create(diff.local as RuleConfig) if diff.added?
        next @client.delete(diff.server as Rule) if diff.removed?
        next @client.update(diff.config as RuleConfig) if diff.changed?
      end
    end
  end
end
