module EmberCLI
  module Helpers
    extend self

    def match_version?(version, requirement)
      version = Gem::Version.new(version)
      requirement = Gem::Requirement.new(requirement)
      requirement.satisfied_by?(version)
    end

    def which(cmd)
      exts = ENV.fetch("PATHEXT", ?;).split(?;, -1).uniq

      ENV.fetch("PATH").split(File::PATH_SEPARATOR).each do |path|
        exts.each do |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable?(exe) && !File.directory?(exe)
        end
      end

      nil
    end

    def non_production?
      !Rails.env.production? && Rails.configuration.consider_all_requests_local
    end

    def override_assets_precompile_task!
      Rake.application.instance_eval do
        @tasks["assets:precompile:original"] = @tasks.delete("assets:precompile")
        Rake::Task.define_task "assets:precompile", [:assets, :precompile] => :environment do
          Rake::Task["assets:clobber"].execute
          Rake::Task["assets:precompile:original"].execute
          EmberCLI.compile!

          EmberCLI.configuration.apps.each do |name, app|
            ember_assets_path = [EmberCLI.root, 'apps', name, 'assets', '.'].join('/')
            ember_fonts_path = [EmberCLI.root, 'apps', name, 'fonts'].join('/')
            rails_assets_path = [Rails.root, 'public', 'assets'].join('/')
            FileUtils.cp_r(ember_assets_path, rails_assets_path)
            FileUtils.cp_r(ember_fonts_path, [Rails.root, 'public'].join('/'))

            fingerprinted_app_js = nil
            fingerprinted_app_css = nil
            fingerprinted_vendor_js = nil
            fingerprinted_vendor_css = nil
            fingerprinted_manifest_json = nil

            Dir["#{rails_assets_path}/*"].each do |fn|
              fn = File.basename(fn)
              fingerprinted_app_js = fn if fn.index("#{app.ember_app_name}-") == 0 && File.extname(fn) == '.js'
              fingerprinted_app_css = fn if fn.index("#{app.ember_app_name}-") == 0 && File.extname(fn) == '.css'
              fingerprinted_vendor_js = fn if fn.index("vendor-") == 0 && File.extname(fn) == '.js'
              fingerprinted_vendor_css = fn if fn.index("vendor-") == 0 && File.extname(fn) == '.css'
              fingerprinted_manifest_json = fn if fn.index("manifest-") == 0 && File.extname(fn) == '.json'
            end
            fingerprinted_manifest_json_path = [rails_assets_path, fingerprinted_manifest_json].join('/')
            manifest = JSON.parse(File.open(fingerprinted_manifest_json_path).read)

            manifest['assets']["#{name}/#{app.ember_app_name}.js"] = fingerprinted_app_js
            manifest['assets']["#{name}/#{app.ember_app_name}.css"] = fingerprinted_app_css
            manifest['assets']["#{name}/vendor.js"] = fingerprinted_vendor_js
            manifest['assets']["#{name}/vendor.css"] = fingerprinted_vendor_css

            File.open(fingerprinted_manifest_json_path,"w") do |f|
              f.write(manifest.to_json)
            end

          end



        end
      end
    end
  end
end
