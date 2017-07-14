describe EmberCli do
  describe ".any?" do
    it "delegates to the collection of applications" do
      allow(EmberCli).to receive(:apps).and_return(
        with_foo: { foo: true },
        witout_foo: { foo: false },
      )

      any_with_foo = EmberCli.any? { |options| options.fetch(:foo) }

      expect(any_with_foo).to be true
    end
  end
end
