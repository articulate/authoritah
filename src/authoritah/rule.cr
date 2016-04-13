require "json"

module Authoritah
  class Rule
    include Mixins::DiffHelpers

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
