describe EmberCli do
  describe ".any?" do
    it "delegates to the collection of applications" do
      stub_apps(
        app_with_foo: { foo: true },
        app_without_foo: { foo: false },
      )

      any_with_foo = EmberCli.any? { |app| app.fetch(:foo) }

      expect(any_with_foo).to be true
    end
  end

  def stub_apps(applications)
    allow(EmberCli).to receive(:apps).and_return(applications)
  end
end
