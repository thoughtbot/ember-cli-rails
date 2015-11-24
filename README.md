# Ember CLI Rails

Unify your EmberCLI and Rails Workflows!

EmberCLI-Rails is designed to give you the best of both worlds:

* Stay up to date with the latest JavaScript technology and EmberCLI addons
* Develop your Rails API and Ember front-ends from within a single process
* Inject Rails-generated content into your EmberCLI application
* Avoid Cross-Origin Resource Sharing gotchas by serving your EmberCLI
  applications and your API from a single domain
* Write truly end-to-end integration tests, exercising your application's entire
  stack through JavaScript-enabled Capybara tests
* Deploy your entire suite of applications with a single `git push`

**EmberCLI-Rails Supports EmberCLI 1.13.x and later.**

## Installation

Add the following to your `Gemfile`:

```ruby
gem "ember-cli-rails"
```

Then run `bundle install`:

```bash
$ bundle install
```

## Usage

First, generate the gem's initializer:

```bash
$ rails generate ember-cli:init
```

This will create the following initializer:

```ruby
# config/initializers/ember.rb

EmberCli.configure do |c|
  c.app :frontend
end
```

The initializer assumes that your Ember application exists in
`Rails.root.join("frontend")`.

If this is not the case, you could

* move your existing Ember application into `Rails.root.join("frontend")`
* configure `frontend` to look for the Ember application in its current
  directory:

```rb
c.app :frontend, path: "~/projects/my-ember-app"
```

* generate a new Ember project:

```bash
$ ember new frontend --skip-git
```

**Initializer options**

- `name` - this represents the name of the Ember CLI application.

- `path` - the path where your Ember CLI application is located. The default
  value is the name of your app in the Rails root.

```ruby
EmberCli.configure do |c|
  c.app :adminpanel # path defaults to `Rails.root.join("adminpanel")`
  c.app :frontend,
    path: "/path/to/your/ember-cli-app/on/disk"
end
```

Next, install the [ember-cli-rails-addon][addon]:

```bash
$ cd path/to/frontend
$ npm install --save-dev ember-cli-rails-addon
```

Be sure that the addon's [`MAJOR` and `MINOR` version][semver] matches the gem's
`MAJOR` and `MINOR` versions.

For instance, if you're using the `0.5.x` version of the gem, specify
`~> 0.5.0` in your Ember app's `package.json`:

```json
{
  "devDependencies": {
    "ember-cli-rails-addon": "~> 0.5.0"
  }
}
```

[addon]: https://github.com/rondale-sc/ember-cli-rails-addon/
[semver]: http://semver.org/

Next, configure Rails to route requests to the `frontend` Ember application:

```rb
# config/routes.rb

Rails.application.routes.draw do
  mount_ember_app :frontend, to: "/"
end
```

Ember requests will be set `params[:ember_app]` to the name of the application.
In the above example, `params[:ember_app] == :frontend`.

**Routing options**

* `to` - The path to handle as an Ember application. This will only apply to
  `format: :html` requests. Additionally, this will handle child routes as well.
  For instance, mounting `mount_ember_app :frontend, to: "/frontend"` will handle a
  `format: :html` request to `/frontend/posts`.
* `controller` - Defaults to `"ember_cli/ember"`
* `action` - Defaults to `"index"`

You should now be able to boot your Rails application, navigate to the `root`
route, and see your EmberCLI app!

## Configuring the Ember controller

By default, routes defined by `ember_app` will be rendered with the internal
`EmberCli::EmberController`. The `EmberCli::EmberController` renders the Ember
application's `index.html` and injects the Rails-generated CSRF tags into the
`<head>`.

To override this behavior, specify the `controller` and `action` options:

```rb
# config/routes

Rails.application.routes.draw do
  mount_ember_app :frontend, to: "/", controller: "application", action: "index"
end
```

To serve the EmberCLI generated `index.html`, use the `render_ember_app`
helper in your view:

```erb
<!-- app/views/application/index.html.erb -->
<%= render_ember_app :frontend %>
```

To inject markup into page, pass in a block that accepts the `head`, and
(optionally) the `body`:

```erb
<!-- app/views/application/index.html.erb -->
<%= render_ember_app :frontend do |head| %>
  <% head.append do %>
    <%= csrf_meta_tags %>
  <% end %>
<% end %>
```

When serving the EmberCLI generated `index.html`, don't use Rails' layout HTML:

```rb
# app/controllers/application.rb
class ApplicationController < ActionController::Base
  def index
    render layout: false
  end
end
```

**NOTE**

When specifying a controller of your own, make sure [the controller is a
descendant of `ApplicationController`][#321], and [`ApplicationController` is a
descendant of `ActionController::Base`][#320].

[#320]: https://github.com/thoughtbot/ember-cli-rails/issues/320
[#321]: https://github.com/thoughtbot/ember-cli-rails/issues/321

### Rendering the EmberCLI generated JS and CSS

In addition to rendering the EmberCLI generated `index.html`, you can inject the
`<script>` and `<link>` tags into your Rails generated views:

```erb
<!-- app/views/application/index.html.erb -->
<%= include_ember_script_tags :frontend %>
<%= include_ember_stylesheet_tags :frontend %>
```

**NOTE**

These helpers are only available for Rails versions `>= 4.0`.

### Multiple Ember CLI apps

In the initializer you may specify multiple Ember CLI apps, each of which can be
referenced with the view helper independently. You'd accomplish this like so:

```ruby
EmberCLI.configure do |c|
  c.app :frontend
  c.app :admin_panel, path: "/somewhere/else"
end
```

Rendering Ember applications at routes other than `/` requires additional setup
to avoid an Ember `UnrecognizedURLError`.

For instance, if you had Ember applications named  `:frontend` and
`:admin_panel` and you wanted to serve them at `/frontend` and `/admin_panel`,
you would set up the following Rails routes:

```rb
# /config/routes.rb
Rails.application.routes.draw do
  mount_ember_app :frontend, to: "/frontend"
  mount_ember_app :admin_panel, to: "/admin_panel"
end
```

You must modify each Ember app's `baseURL` to point to the correct route:

```javascript
// app/frontend/config/environment.js

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'frontend',
    environment: environment,
    baseURL: '/frontend', // originally '/'
    ...
  }
}

// app/admin_panel/config/environment.js

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'admin_panel',
    environment: environment,
    baseURL: '/admin_panel',  // originally '/'
    ...
  }
}
```

## CSRF Tokens

Your Rails controllers, by default, are expecting a valid authenticity token to be submitted with non-`GET` requests.
Without it you'll receive a `422 Unprocessable Entity` error, specifically: `ActionController::InvalidAuthenticityToken`.

In order to add that token to your requests, you need to add into your template:

```erb
<!-- app/views/application/index.html.erb -->
<%= render_ember_app :frontend do |head| %>
  <% head.append do %>
    <%= csrf_meta_tags %>
  <% end %>
<% end %>
```

The default `EmberCli::EmberController` and its accompanying view handle this
for you by default.

However, if you specify your own controller, make sure to append CSRF tags to
your view's `<head>`.

The [ember-cli-rails-addon][addon] addon will inject an initializer into your
app to set outgoing requests' `X-CSRF-TOKEN` header to the value injected by
Rails.

### Integrating with Rake

EmberCLI Rails exposes the `ember:test` Rake task to execute Ember's test suite.

If you're using Rake to run your test suite, make sure to configure your test
task to depend on `ember:test`.

For example, to configure a bare `rake` command to run both RSpec and Ember test
suites, configure the `default` task to depend on both `spec` and `ember:test`.

```rb
task default: [:spec, "ember:test"]
```

## Serving from multi-process servers in development

If you're using a multi-process server ([Puma], [Unicorn], etc.) in development,
make sure it's configured to run a single worker process.

Without restricting the server to a single process, [it is possible for multiple
EmberCLI runners to clobber each others' work][#94].

[Puma]: https://github.com/puma/puma
[Unicorn]: https://rubygems.org/gems/unicorn
[#94]: https://github.com/thoughtbot/ember-cli-rails/issues/94#issuecomment-77627453

## Enabling LiveReload

In order to get LiveReload up and running with Ember CLI Rails, you can install
[guard](https://github.com/guard/guard) and
[guard-livereload](https://github.com/guard/guard-livereload) gems, run `guard
init` and then add the following to your `Guardfile`.

```ruby
guard "livereload" do
  # ...
  watch %r{your-appname/app/\w+/.+\.(js|hbs|html|css|<other-extensions>)}
  # ...
end
```

This tells Guard to watch your Ember CLI app for any changes to the JavaScript,
Handlebars, HTML, or CSS files within `app` path. Take note that other
extensions can be added to the line (such as `coffee` for CoffeeScript) to
watch them for changes as well.

*NOTE:* Ember CLI creates symlinks in `your-appname/tmp` directory, which cannot
 be handled properly by Guard. This might lead to performance issues on some
 platforms (most notably on OSX), as well as warnings being printed by latest
 versions of Guard. As a work-around, one might use
 [`directories`](https://github.com/guard/guard/wiki/Guardfile-DSL---Configuring-Guard#directories)
 option, explicitly specifying directories to watch, e.g. adding the following
 to the `Guardfile`.

```ruby
# also add directories that need to be watched by other guard plugins
directories %w[app config lib spec your-appname/app]
```

## Heroku

To configure your Ember CLI Rails app to be ready to deploy on Heroku:

1. Run `rails g ember-cli:heroku` generator
1. [Add the NodeJS buildpack][buildpack] and configure NPM to include the
   `bower` dependency's executable file.

```sh
$ heroku buildpacks:clear
$ heroku buildpacks:add --index 1 https://github.com/heroku/heroku-buildpack-nodejs
$ heroku buildpacks:add --index 2 https://github.com/heroku/heroku-buildpack-ruby
$ heroku config:set NPM_CONFIG_PRODUCTION=false
$ heroku config:unset SKIP_EMBER
```

You should be ready to deploy.

The generator will disable Rails' JavaScript compression by declaring:

```rb
config.assets.js_compressor = nil
```

This is recommended, but might not work for projects that have both Asset
Pipeline and EmberCLI generated JavaScript.

To reverse this change, reconfigure Sprockets to use the `uglifier` gem:

```rb
config.assets.js_compressor = :uglifier
```

**NOTE** Run the generator each time you introduce additional EmberCLI
applications into the project.

[buildpack]: https://devcenter.heroku.com/articles/using-multiple-buildpacks-for-an-app#adding-a-buildpack

## Capistrano

To deploy an EmberCLI-Rails application with Capistrano, make sure your
EmberCLI app's `package.json` file includes the `bower` package as a development
dependency:

```json
{
  "devDependencies": {
    "bower": "*"
  }
}
```

## Experiencing Slow Build/Deploy Times?
Remove `ember-cli-uglify` from your `package.json` file, and run
`npm remove ember-cli-uglify`. This will improve your build/deploy
time by about 10 minutes.

The reason build/deploy times were slow is because ember uglified the JS and
then added the files to the asset pipeline. Rails would then try and uglify
the JS again, and this would be considerably slower than normal.

See also the note on [Javascript minification](#javascript-minification)

## JavaScript minification

When pre-compiling assets in production, you will want to
ensure that you are not minifying your JavaScript twice: once with EmberCLI's
build tools and once with the Asset Pipeline. Repeated minification is wasteful
and can increase deployment times exponentially.

You can either disable minification in your EmberCLI application's
`ember-cli-build.js`:

```javascript
/* global require, module */
var EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  var app = new EmberApp({
    minifyJS: false,
  });

  // ...
};
```

or in your Rails application's `config/environments/production.rb`:

```ruby
Rails.application.configure do
  config.assets.js_compressor = nil
end
```

## Additional Information

When running in the development environment, Ember CLI Rails runs `ember build`
with the `--output-path` and `--watch` flags on. The `--watch` flag tells
Ember CLI to watch for file system events and rebuild when an Ember CLI file is
changed. The `--output-path` flag specifies where the distribution files will
be put. Ember CLI Rails does some fancy stuff to get it into your asset path
without polluting your git history. Note that for this to work, you must have
`config.consider_all_requests_local = true` set in
`config/environments/development.rb`, otherwise the middleware responsible for
building Ember CLI will not be enabled.

Alternatively, if you want to override the default behavior in any given Rails
environment, you can manually set the `config.use_ember_middleware` and
`config.use_ember_live_recompilation` flags in the environment-specific config
file.

### `ASSET_HOST`

Used by [the addon][addon] during fingerprinting.

When compiling an Ember app named `"frontend"` from within Rails,
the addon will prepend the generated asset paths with:

      ${ASSET_HOST}/assets/frontend/

### `CDN_HOST`

Behaves the same way as `ASSET_HOST`, acting as a fallback.

### `RAILS_ENV`

While being managed by EmberCLI Rails, EmberCLI process will have
access to the `RAILS_ENV` environment variable. This can be helpful to detect
the Rails environment from within the EmberCLI process.

This can be useful to determine whether or not EmberCLI is running in its own
standalone process or being managed by Rails.

For example, to enable [ember-cli-mirage][ember-cli-mirage] API responses in
`development` while being run outside of Rails (while run by `ember serve`),
check for the absence of the `RAILS_ENV` environment variable:

```js
// config/environment.js
if (environment === 'development') {
  ENV['ember-cli-mirage'] = {
    enabled: typeof process.env.RAILS_ENV === 'undefined',
  }
}
```

`RAILS_ENV` will be absent in production builds.

[ember-cli-mirage]: http://ember-cli-mirage.com/docs/latest/

### `SKIP_EMBER`

To disable asset compilation entirely, set an environment variable
`SKIP_EMBER=1`.

This can be useful when an application's frontend is developed locally with
EmberCLI-Rails, but deployed separately (for example, with
[ember-cli-deploy][ember-cli-deploy]).

[ember-cli-deploy]: https://github.com/ember-cli/ember-cli-deploy

#### Ember Dependencies

Ember has several dependencies. Some of these dependencies might already be
present in your asset list. For example jQuery is bundled in `jquery-rails` gem.
If you have the jQuery assets included on your page you may want to exclude them
from the Ember distribution. You can do so by setting the `exclude_ember_deps`
option like so:

```ruby
EmberCli.configure do |c|
  c.app :frontend, exclude_ember_deps: "jquery"
  c.app :admin_panel, exclude_ember_deps: ["jquery", "handlebars"]
end
```

jQuery and Handlebars are the main use cases for this flag.

## Ruby and Rails support

This project supports:

* Ruby versions `>= 2.1.0`
* Rails versions `3.2.x` and `>=4.1.x`.

[Rendering EmberCLI-generated assets through Sprockets](asset-helpers) is
**NOT** supported for Rails `3.2.x`.

To learn more about supported versions and upgrades, read the [upgrading guide].

[asset-helpers]: #rendering-the-embercli-generated-js-and-css
[upgrading guide]: /UPGRADING.md

## Contributing

See the [CONTRIBUTING] document.
Thank you, [contributors]!

  [CONTRIBUTING]: CONTRIBUTING.md
  [contributors]: https://github.com/thoughtbot/ember-cli-rails/graphs/contributors

## License

Open source templates are Copyright (c) 2015 thoughtbot, inc.
It contains free software that may be redistributed
under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE.txt

## About

ember-cli-rails was originally created by
[Pavel Pravosud][rwz] and
[Jonathan Jackson][rondale-sc].

ember-cli-rails is maintained by [Sean Doyle][seanpdoyle] and [Jonathan
Jackson][rondale-sc].

[rwz]: https://github.com/rwz
[rondale-sc]: https://github.com/rondale-sc
[seanpdoyle]: https://github.com/seanpdoyle

![thoughtbot](https://thoughtbot.com/logo.png)

ember-cli-rails is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open source software!
See [our other projects][community]
or [hire us][hire] to help build your product.

  [community]: https://thoughtbot.com/community?utm_source=github
  [hire]: https://thoughtbot.com/hire-us?utm_source=github
