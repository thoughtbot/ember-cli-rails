require "ember-cli-rails"

describe "User tests Ember app" do
  it "exits with exit status of 0" do
    passed = EmberCli["my-app"].test

    expect(passed).to be true
  end
end
