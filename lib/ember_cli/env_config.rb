module EmberCli
  class App
    class EnvConfig
      attr_reader :env_file_path

      RAILS_ENV_CHECK = "typeof process.env.RAILS_ENV === 'undefined'".freeze

      def initialize(env_file_path)
        @env_file_path = env_file_path
      end

      def update_without_mirage
        update_config_file do |tmp, line|
          replace_common_config(line, tmp)
        end
      end

      def update_with_mirage
        update_config_file do |tmp, line|
          tmp = replace_common_config(line, tmp)
          add_mirage_test_config_if_needed(line, tmp)
        end
      end

      def update_config_file
        tmp = StringIO.open
        File.open(env_file_path, "r") do |f|
          f.each_line { |line| tmp = yield(tmp, line) }
        end
        write_config_file(tmp)
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

      def add_mirage_test_config_if_needed(line, tmp)
        if line["if (environment === 'test') {"]
          return tmp unless needs_mirage_update?
          content = "    ENV['ember-cli-mirage'] = { enabled: typeof "\
                    "#{RAILS_ENV_CHECK} };"
          tmp.puts(content)
        end
        tmp
      end

      def needs_mirage_update?
        IO.read(env_file_path)[
          "if (environment === 'test') {\n    ENV['ember-cli-mirage'] ="
        ]
      end

      def write_config_file(stream)
        stream.seek(0)
        File.open(env_file_path, "w") { |f| f.puts(stream.read) }
      end
    end
  end
end
