require "json"

module Authoritah
  class Rule
    include Mixins::DiffHelpers
    include Mixins::Serializer

    serialize_with :uuid, :name, :script_file, :stage, :enabled
    def_equals_type RuleConfig, :name, :uuid, :enabled, :stage, :script

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
      @name.split(" ").first
    end

    def name
      @name.split(" ")[1..-1].join(" ")
    end

    def save_script(path = "./rules")
      @script_file = "#{path}/#{name}.js"

      Dir.mkdir_p(path) unless Dir.exists? path

      # add trailing newline
      File.write(@script_file.not_nil!, script + "\n")
      path
    end
  end

  class RemovedRule
    getter :id

    def initialize(@id)
    end
  end
end
