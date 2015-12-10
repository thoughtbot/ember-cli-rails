module EmberCli
  class HerokuGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    namespace "ember:heroku"

    def copy_package_json_file
      template "package.json.erb", "package.json"
    end

    def copy_setup_heroku_file
      template "bin_heroku_install.erb", "bin/heroku_install"
      run "chmod a+x bin/heroku_install"
    end

    def config_js_compressor
      production_config = "config/environments/production.rb"

      inject_into_file production_config, before: "end\n" do
        <<-RUBY
  config.assets.js_compressor = nil
        RUBY
      end
    end

    def inject_12factor_gem
      gem "rails_12factor", group: [:staging, :production]
    end

    def app_paths
      EmberCli.apps.values.map do |app|
        app.root.relative_path_from(Rails.root)
      end
    end
  end
end
