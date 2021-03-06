require "./spec_helper"

def new_client(setup)
  fake_client = double()
  fake_client.stub(:close)

  yield fake_client

  Authoritah::Auth0Client.new(fake_client, setup)
end

module Authoritah
  describe Auth0Client do
    setup = Authoritah::Setup.new("./spec/fixtures/jwt.json")
    jwt = Authoritah::JWTBuilder.new(setup).generate

    # header stubs
    headers = HTTP::Headers.new.tap do |headers|
      headers.add "Authorization", "Bearer #{jwt}"
      headers.add "Content-Type", "application/json"
      headers.add "User-Agent", "Authoritah/#{Authoritah::VERSION}"
    end

    context "fetch all" do
      it "can get all rules" do
        client = new_client(setup) do |mock|
          mock.should_receive(:get)
              .with("/api/v2/rules", headers)
              .and_return(load_response("rules"))
        end

        res = client.fetch_all

        res.all? { |rule| rule.is_a? Rule }.should be_true
      end

      it "returns empty array if not found" do
        client = new_client(setup) do |mock|
          mock.should_receive(:get)
              .with("/api/v2/rules", headers)
              .and_return(build_response({error: "not found"}, 404))
        end

        res = client.fetch_all

        res.empty?.should be_true
        res.should be_a Array(Rule)
      end
    end

    context "fetch single" do
      it "can get all rules" do
        client = new_client(setup) do |mock|
          mock.should_receive(:get)
              .with("/api/v2/rules/123", headers)
              .and_return(load_response("rule"))
        end

        res = client.fetch("123")

        res.should be_a(Rule)
      end

      it "raises an error if not found" do
        client = new_client(setup) do |mock|
          mock.should_receive(:get)
              .with("/api/v2/rules/456", headers)
              .and_return(build_response({error: "not found"}, 404))
        end

        expect_raises Auth0Client::NotFound, /for '456'/ do
          client.fetch("456")
        end
      end
    end

    context "create" do
      rule = config_fixture("rule")

      it "posts a new rule" do
        client = new_client(setup) do |mock|
          mock.should_receive(:post)
              .with("/api/v2/rules", headers, rule.serialize.to_json)
              .and_return(load_response("rule", 201))
        end

        res = client.create(rule)
        res.should be_a(Rule)
        res.should eq rule
      end

      it "fails with message on error" do
        client = new_client(setup) do |mock|
          mock.should_receive(:post)
              .with("/api/v2/rules", headers, rule.serialize.to_json)
              .and_return(build_response({message: "fails dot com"}, 400))
        end

        expect_raises Auth0Client::APIError, /fails dot com/ do
          client.create(rule)
        end
      end
    end

    context "delete" do
      rule = rule_fixture("rule")

      it "deletes a rule given a rule" do
        client = new_client(setup) do |mock|
          mock.should_receive(:delete)
              .with("/api/v2/rules/#{rule.id}", headers)
              .and_return(empty_response(204))
        end

        res = client.delete(rule)
        res.should be_a RemovedRule
        res.id.should eq rule.id
      end

      it "deletes a rule given an id" do
        client = new_client(setup) do |mock|
          mock.should_receive(:delete)
              .with("/api/v2/rules/#{rule.id}", headers)
              .and_return(empty_response(204))
        end

        res = client.delete(rule.id)
        res.should be_a RemovedRule
        res.id.should eq rule.id
      end

      it "fails with message on error" do
        client = new_client(setup) do |mock|
          mock.should_receive(:delete)
              .with("/api/v2/rules/400", headers)
              .and_return(build_response({message: "fails dot com"}, 400))
        end

        expect_raises Auth0Client::APIError, /fails dot com/ do
          client.delete("400")
        end
      end
    end

    context "update" do
      config = config_fixture("rule")

      # this will get set during the compare
      config.id = 123

      it "deletes a rule given a rule" do
        client = new_client(setup) do |mock|
          mock.should_receive(:patch)
              .with("/api/v2/rules/#{config.id}", headers, config.for_update.to_json)
              .and_return(load_response("rule", 200))
        end

        res = client.update(config)
        res.should be_a Rule
        res.should eq config
      end

      it "fails with message on error" do
        client = new_client(setup) do |mock|
          mock.should_receive(:patch)
              .with("/api/v2/rules/#{config.id}", headers, config.for_update.to_json)
              .and_return(build_response({message: "fails dot com"}, 400))
        end

        expect_raises Auth0Client::APIError, /fails dot com/ do
          client.update(config)
        end
      end
    end
  end
end
