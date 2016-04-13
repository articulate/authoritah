require "./spec_helper"

module Authoritah
  describe JWTBuilder do
    setup = Setup.new("./spec/fixtures/jwt.json")
    builder = JWTBuilder.new("123", "456", setup)
    static_key = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMjMiLCJzY29wZXMiOnsicnVsZXMiOnsiYWN0aW9ucyI6WyJyZWFkIiwidXBkYXRlIiwiZGVsZXRlIiwiY3JlYXRlIl19fSwiaWF0IjoxNDYwNTc3NDM1LCJqdGkiOiIzOGFjYzc5YmFkZDg3MDAzMzAwYWVhNDhlZTNlYjNjNyJ9.c9llP89rtH6LgGCDG0dQDd9aa4Js2Tb0QhoiM_uXnTk"

    it "can generate a JWT for auth0 use" do
      key = builder.generate
      key.should eq static_key
    end

    # Stores the iat and jti for reuse
    it "does not change if generated again" do
      builder.generate.should eq static_key
    end

    it "does change if refresh is requested" do
      builder.refresh.should_not eq static_key
    end

    # reset the keys for the static generation tests
    setup.set("jwt.created_at", 1460577435.to_i64)
    setup.set("jwt.uid", "38acc79badd87003300aea48ee3eb3c7")
  end
end
