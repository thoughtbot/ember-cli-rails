module EmberCli
  class App
    module ConfigHelper
      extend self

      RAILS_ENV_CHECK = "typeof process.env.RAILS_ENV === 'undefined'".freeze

      def update_without_mirage(config_path)
        update_config_file(config_path) do |tmp, line|
          replace_common_config(line, tmp)
        end
      end

      def update_with_mirage(config_path)
        update_config_file(config_path) do |tmp, line|
          tmp = replace_common_config(line, tmp)
          add_mirage_test_config_if_needed(config_path, line, tmp)
        end
      end

      def update_config_file(config_path)
        tmp = StringIO.open
        File.open(config_path, "r") do |f|
          f.each_line { |line| tmp = yield(tmp, line) }
        end
        write_config_file(config_path, tmp)
      end

      private

      def replace_common_config(line, tmp)
        content = if line["ENV.locationType = 'none'"]
                    "    ENV.locationType = #{RAILS_ENV_CHECK}"\
                    " ? 'none' : ENV.locationType;"
                  elsif line["ENV.APP.rootElement = '#ember-testing'"]
                    "    ENV.APP.rootElement = #{RAILS_ENV_CHECK}"\
                    " ? '#ember-testing' : ENV.rootElement;"
                  else
                    line
                  end
        tmp.puts(content)
        tmp
      end

      def add_mirage_test_config_if_needed(config_path, line, tmp)
        if line["if (environment === 'test') {"]
          unless needs_mirage_update?(config_path)
            content = "    ENV['ember-cli-mirage'] = { enabled: typeof "\
                      "#{RAILS_ENV_CHECK} };"
            tmp.puts(content)
          end
        end
        tmp
      end

      def needs_mirage_update?(config_path)
        IO.read(config_path)[
          "if (environment === 'test') {\n    ENV['ember-cli-mirage'] ="
        ]
      end

      def write_config_file(config_path, stream)
        stream.seek(0)
        File.open(config_path, "w") { |f| f.puts(stream.read) }
      end
    end
  end
end
