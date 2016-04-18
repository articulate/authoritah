require "http/client"
require "json"

module Authoritah
  class Auth0Client
    include Mixins::Speak

    class NotFound < Exception; end

    class APIError < Exception; end

    RULES_API_PATH = "https://%s.auth0.com/"

    # Create an AuthClient from a `domain`
    def initialize(@setup : Setup)
      domain = @setup.get_string("auth0.domain", "")
      uri = URI.parse(RULES_API_PATH % domain)

      @client = HTTP::Client.new(uri)
    end

    # Create a AuthClient from a pre-configured HTTP client. This allows
    # you to configure your own HTTP client as you wish and then pass it directly
    # to AuthClient. Must respond to `get(path)` with the root URL set
    def initialize(@client, @setup : Setup)
    end

    def fetch_all : Array(Rule)
      response = @client.get(rules_path, headers) as HTTP::Client::Response

      case response.status_code
      when 404
        [] of Rule
      when 200
        build_rules(response.body)
      else
        raise APIError.new("Invalid API response (status code #{response.status_code})")
      end
    ensure
      @client.close
    end

    def fetch(id : String)
      response = @client.get(rule_path(id), headers) as HTTP::Client::Response

      case response.status_code
      when 404
        raise NotFound.new("No record found for '#{id}'")
      when 200
        build_rule(response.body)
      else
        raise APIError.new("Invalid API response (status code #{response.status_code})")
      end
    ensure
      @client.close
    end

    def create(config : RuleConfig)
      response = @client.post(rules_path, headers, config.serialize.to_json) as HTTP::Client::Response

      case response.status_code
      when 201
        rule = build_rule(response.body)
        ok "Rule created with id #{rule.id}"
        rule
      else
        body = JSON.parse response.body
        raise APIError.new("Invalid API response (status code #{response.status_code}): #{body["message"]}")
      end
    ensure
      @client.close
    end

    def update(config : RuleConfig)
      response = @client.patch(rule_path(config.id), headers, config.for_update.to_json) as HTTP::Client::Response

      case response.status_code
      when 200
        rule = build_rule(response.body)
        warn "Rule '#{rule.id}' updated."
        rule
      else
        body = JSON.parse response.body
        raise APIError.new("Invalid API response (status code #{response.status_code}): #{body["message"]}")
      end
    ensure
      @client.close
    end

    def delete(rule : Rule)
      delete(rule.id)
    end

    def delete(id : String)
      response = @client.delete(rule_path(id), headers) as HTTP::Client::Response

      case response.status_code
      when 204
        warn "Rule '#{id}' removed."
        RemovedRule.new(id)
      else
        body = JSON.parse response.body
        raise APIError.new("Invalid API response (status code #{response.status_code}): #{body["message"]}")
      end
    ensure
      @client.close
    end

    private def rules_path
      "/api/v2/rules"
    end

    private def rule_path(id)
      rules_path + "/#{id}"
    end

    private def headers
      HTTP::Headers.new.tap do |headers|
        headers.add "Authorization", "Bearer #{jwt}"
        headers.add "Content-Type", "application/json"
        headers.add "User-Agent", "Authoritah/#{Authoritah::VERSION}"
      end
    end

    private def jwt
      JWTBuilder.new(@setup).generate
    end

    private def build_rules(items) : Array(Rule)
      return [] of Rule if items.empty?

      Array(Rule).from_json(items)
    end

    private def build_rule(item)
      Rule.from_json(item)
    end
  end
end
