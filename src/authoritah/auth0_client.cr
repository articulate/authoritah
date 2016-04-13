require "http/client"
require "json"

module Authoritah
  class Auth0Client
    include Mixins::Speak

    RULES_API_PATH = "https://%s.auth0.com/"

    # Create an AuthClient from a `domain`
    def initialize(@setup : Setup)
      domain = @setup.get_string("auth0.domain", "")
      uri = URI.parse(RULES_API_PATH % domain)
      puts uri

      @client = HTTP::Client.new(uri)
    end

    # Create a AuthClient from a pre-configured HTTP client. This allows
    # you to configure your own HTTP client as you wish and then pass it directly
    # to AuthClient. Must respond to `get(path)` with the root URL set
    def initialize(@client, @setup : Setup)
    end

    def fetch_all
      response = @client.get("/api/v2/rules", headers) as HTTP::Client::Response

      case response.status_code
      when 404
        [] of Rule
      when 200
        build_rules(response.body)
      else
        error "Invalid API response (status code #{response.status_code})"
      end
    ensure
      @client.close
    end

    def fetch(id : String)
      response = @client.get("/#{id}", headers) as HTTP::Client::Response

      case response.status_code
      when 404
        error "No record found for '#{id}'"
      when 200
        build_rule(response.body)
      else
        error "Invalid API response (status code #{response.status_code})"
      end
    ensure
      @client.close
    end

    def create(rule : Rule)
    end

    def update(rule : Rule)
    end

    def delete(rule : Rule)
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
      return Array(Rule).new if items.empty?

      Array(Rule).from_json(items)
    end

    private def build_rule(item)
      Rule.from_json(item)
    end
  end
end
