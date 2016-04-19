require "yaml"

module Authoritah
  class RuleConfig
    include Mixins::DiffHelpers
    include Mixins::Serializer

    def_equals_type Rule, :name, :uuid, :enabled, :stage, :script
    serialize_with({
      name:    serialize_name,
      script:  script,
      enabled: enabled,
      stage:   stage,
      order:   order,
    })
    ignore_update :stage

    # TODO: Order ought to be set as part of the config
    property :order, :id

    YAML.mapping({
      name:        String,
      uuid:        String,
      enabled:     Bool,
      script_file: String,
      stage:       String,
    })

    def serialize_name
      "#{uuid} #{name}"
    end

    def script
      File.read(script_file).chomp
    end

    def diff(other : Rule)
      other.diff(self)
    end
  end
end
