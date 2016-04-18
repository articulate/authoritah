require "json"

module Authoritah
  class Rule
    include Mixins::DiffHelpers
    include Mixins::Serializer

    serialize_with :name, :id, :enabled, :order, :stage
    def_equals_type RuleConfig, :name, :id, :enabled, :stage, :script

    JSON.mapping({
      name:    String,
      id:      String,
      enabled: Bool,
      script:  String,
      order:   Int64,
      stage:   String,
    })
  end
end
