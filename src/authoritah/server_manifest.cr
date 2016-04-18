module Authoritah
  class ServerManifest
    def initialize(@client)
      @rules = [] of Rule
    end

    def rules
      return @rules unless @rules.empty?
      @rules = @client.fetch_all as Array(Rule)
    end

    def ids
      rules.map &.id
    end

    def find(id : String)
      rules.find { |r| r.id == id }
    end

    def find(cfg : RuleConfig)
      find(cfg.id)
    end

    def find(ids : Array(String))
      rules.select { |r| ids.includes? r.id }
    end
  end
end
