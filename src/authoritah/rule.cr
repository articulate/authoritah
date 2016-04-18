require "json"

module Authoritah
  class Rule
    include Mixins::DiffHelpers
    include Mixins::Serializer

    serialize_with :uuid, :name, :script_file, :stage, :enabled
    def_equals_type RuleConfig, :name, :id, :enabled, :stage, :script

    property :script_file

    JSON.mapping({
      name:    String,
      id:      String,
      enabled: Bool,
      script:  String,
      order:   Int64,
      stage:   String,
    })

    def uuid
      self.id
    end

    def save_script(@script_file = "./rules/#{name}.js")
      script_dir = File.dirname(@script_file.not_nil!)
      Dir.mkdir_p(script_dir) unless Dir.exists? script_dir

      # add trailing newline
      File.write(@script_file.not_nil!, script + "\n")
      script_file
    end
  end

  class RemovedRule
    getter :id

    def initialize(@id)
    end
  end
end
