require "yaml"

module Authoritah
  class RuleConfig
    include Mixins::DiffHelpers

    def_equals_type Rule, :name, :id, :enabled, :stage, :script

    YAML.mapping({
      name:        String,
      uuid:        String,
      enabled:     Bool,
      script_file: String,
      stage:       String,
    })

    def id
      uuid
    end

    def script
      File.read(script_file).chomp
    end
  end
end
