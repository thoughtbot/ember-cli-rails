module EmberCLI
  class HerokuGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    namespace "ember-cli:heroku"

    gem "rails_12factor", group: [:staging, :production]

    def copy_buildpack_file
      copy_file "buildpacks", ".buildpacks"
    end

    def copy_package_json_file
      template "package.json.erb", "package.json"
    end

    def apps
      EmberCLI.apps.keys
    end
  end
end
