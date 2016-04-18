require "json"

module Authoritah
  class Rule
    include Mixins::DiffHelpers
    include Mixins::Serializer

    serialize_with :name, :id, :enabled, :order, :stage
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

    def save_script(@script_file = "./rules/#{name}.js")
      script_dir = File.dirname(@script_file.not_nil!)
      Dir.mkdir_p(script_dir) unless Dir.exists? script_dir

      File.write(@script_file.not_nil!, script)
    end
  end
end
