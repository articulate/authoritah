module Authoritah
  module Mixins::Parseable
    alias Terminals = String | Bool | Int64 | Float64 | Nil
    alias Type = Terminals | Array(Type) | Hash(String, Type)

    alias Nested = Hash(String, Type) | Array(Type)

    # Don't allow nil values or enumerable types
    # that have no elements
    private def valid_value?(value)
      !value.is_a?(Nil) &&
        !(value.is_a?(Nested) && value.empty?)
    end

    private def to_hash(items : Array)
      # items.map { |v| to_hash(v) }.compact
      values = [] of Type

      items.each do |item|
        value = to_hash(item)
        values << value if valid_value?(value)
      end

      array_or_first(values)
    end

    private def to_hash(items : Hash(K, V))
      items.reduce(Hash(String, Type).new) do |memo, k, v|
        value = to_hash(v)

        memo[k.to_s] = value if valid_value?(value)
        memo
      end
    end

    # for diff purposes, return singular element
    private def array_or_first(array)
      array.size == 1 ? array.first : array
    end
  end
end
