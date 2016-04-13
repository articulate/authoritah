require "./spec_helper"

def new_client(setup)
  fake_client = double
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
    end

    context "fetch all" do
      it "can get all rules" do
        client = new_client(setup) { |mock| mock.should_receive(:get).with("/", headers).and_return(load_response("rules")) }

        res = client.fetch_all

        res.all? { |rule| rule.is_a? Rule }.should be_true
      end

      it "returns empty array if not found" do
        client = new_client(setup) { |mock| mock.should_receive(:get).with("/", headers).and_return(build_response({error: "not found"}, 404)) }

        res = client.fetch_all

        res.empty?.should be_true
        res.should be_a Array(Rule)
      end
    end

    context "fetch single" do
      it "can get all rules" do
        client = new_client(setup) { |mock| mock.should_receive(:get).with("/123", headers).and_return(load_response("rule")) }

        res = client.fetch("123")

        res.should be_a(Rule)
      end

      it "exits with code 1 if not found" do
        client = new_client(setup) { |mock| mock.should_receive(:get).with("/456", headers).and_return(build_response({error: "not found"}, 404)) }

        process = fork { client.fetch("456") }
        process.wait.exit_code.should eq 1
      end
    end

    context "create" do
    end
  end
end
