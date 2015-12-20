require "ember_cli/helpers"

describe EmberCli::Helpers do
  describe ".current_environment" do
    context "when EMBER_ENV is set" do
      it "returns the value of EMBER_ENV" do
        stub_env("EMBER_ENV" => "staging")

        current_environment = EmberCli::Helpers.current_environment

        expect(current_environment).to eq "staging"
      end
    end

    context "when test" do
      it "returns test" do
        stub_rails_env("test")

        current_environment = EmberCli::Helpers.current_environment

        expect(current_environment).to eq "test"
      end
    end

    context "when development" do
      it "returns development" do
        stub_rails_env("development")

        current_environment = EmberCli::Helpers.current_environment

        expect(current_environment).to eq "development"
      end
    end

    context "when anything else" do
      it "returns production" do
        stub_rails_env("staging")

        current_environment = EmberCli::Helpers.current_environment

        expect(current_environment).to eq "production"
      end
    end
  end

  def stub_env(key_to_value)
    allow(ENV).
      to receive(:fetch).
      with(key_to_value.keys.first).
      and_return(key_to_value.values.first)
  end

  def stub_rails_env(env)
    allow(Rails).
      to receive(:env).
      and_return(env.to_s)
  end
end
