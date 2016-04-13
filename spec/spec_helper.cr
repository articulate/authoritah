require "spec"
require "mock"
require "../src/authoritah"

def json_fixture(name)
  File.read("./spec/fixtures/#{name}.json")
end

def yaml_fixture(name)
  File.read("./spec/fixtures/#{name}.yaml")
end

def rule_fixture(name)
  Authoritah::Rule.from_json json_fixture(name)
end

def config_fixture(name)
  Authoritah::RuleConfig.from_yaml yaml_fixture(name)
end

def build_response(body : Hash | Nil, status = 200)
  build_response(body.to_json, status)
end

def build_response(body : String, status = 200)
  HTTP::Client::Response.new status, body: body
end

def load_response(name)
  build_response json_fixture(name)
end
