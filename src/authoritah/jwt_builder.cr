require "base64"
require "jwt"
require "secure_random"

module Authoritah
  class JWTBuilder
    DEFAULT_SCOPE = {
      rules: {
        actions: [
          "read",
          "update",
          "delete",
          "create",
        ],
      },
    }

    def self.new(key : String, secret : String, default_file : String = "./.authoritah")
      new key, secret, Setup.new(default_file)
    end

    def initialize(@key : String, @secret : String, @setup : Setup)
    end

    def initialize(@setup : Setup)
      @key = @setup.get_string("auth0.key", "")
      @secret = @setup.get_string("auth0.secret", "")
    end

    private def decoded_secret
      Base64.decode_string @secret
    end

    def refresh
      @setup.remove "jwt.created_at", "jwt.uid"
      generate
    end

    def generate
      time = @setup.get("jwt.created_at") { Time.now.epoch }
      jti = @setup.get("jwt.uid") { SecureRandom.hex }

      JWT.encode({
        aud:    @key,
        scopes: DEFAULT_SCOPE,
        iat:    time,
        jti:    jti,
      }, decoded_secret, "HS256")
    end
  end
end
