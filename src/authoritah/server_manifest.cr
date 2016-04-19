module Authoritah
  class ServerManifest
    def initialize(@client)
      @rules = [] of Rule
    end

    def rules
      return @rules unless @rules.empty?
      @rules = @client.fetch_all as Array(Rule)
    end

    def uuids
      rules.map &.uuid
    end

    def find(uuid : String)
      rules.find { |r| r.uuid == uuid }
    end

    def find(cfg : RuleConfig)
      find(cfg.uuid)
    end

    def find(uuids : Array(String))
      rules.select { |r| uuids.includes? r.uuid }
    end
  end
end
