require "./parseable"

module Authoritah
  module Mixins::JSONToHash
    include Parseable

    private def to_hash(item : JSON::Any)
      to_hash(item.raw)
    end

    private def to_hash(item : Terminals)
      item
    end
  end
end
