require "spec"
require "mock"
require "../src/authoritah"

class FakeClient
  def initialize
    @rules = Array(Authoritah::Rule).from_json(json_fixture("rules"))
  end

  def fetch_all
    @rules
  end

  def create(model)
    "yes"
  end

  def update(model)
    "no"
  end

  def delete(model)
    "okay"
  end
end

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

def build_response(body : Hash, status = 200)
  build_response(body.to_json, status)
end

def empty_response(status)
  HTTP::Client::Response.new status
end

def build_response(body : String, status = 200)
  HTTP::Client::Response.new status, body: body
end

def load_response(name, status = 200)
  build_response json_fixture(name), status
end
