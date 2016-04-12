require "spec"
require "../src/cartman"

def rule_fixture(name)
  Cartman::Rule.from_json File.read("./spec/fixtures/#{name}.json")
end

def config_fixture(name)
  Cartman::RuleConfig.from_yaml File.read("./spec/fixtures/#{name}.yaml")
end
