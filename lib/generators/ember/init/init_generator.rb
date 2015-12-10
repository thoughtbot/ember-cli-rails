module EmberCli
  class InitGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    namespace "ember:init"

    def copy_initializer_file
      copy_file "initializer.rb", "config/initializers/ember.rb"
    end
  end
end
