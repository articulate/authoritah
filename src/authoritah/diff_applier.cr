module Authoritah
  class DiffApplier
    def initialize(@diffs : Array(Diff), @client)
    end

    def apply
      @diffs.map do |diff|
        next @client.create(diff.local) if diff.added?
        next @client.delete(diff.server) if diff.removed?
        next @client.update(diff.local) if diff.changed?
      end
    end
  end
end
