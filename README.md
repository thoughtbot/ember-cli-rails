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
* Deploy your entire suite of applications to Heroku with a single `git push`

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
$ rails generate ember:init
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
$ ember install ember-cli-rails-addon
```

Be sure that the addon's [`MAJOR` and `MINOR` version][semver] matches the gem's
`MAJOR` and `MINOR` versions.

For instance, if you're using the `0.6.x` version of the gem, specify
`~> 0.6.0` in your Ember app's `package.json`:

```json
{
  "devDependencies": {
    "ember-cli-rails-addon": "~> 0.6.0"
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

Finally, install your Ember application's dependencies:

```bash
$ rake ember:install
```

Boot your Rails application, navigate to `"/"`, and view your EmberCLI
application!

## Heroku

To configure your EmberCLI-Rails applications for Heroku:

1. Execute `rails generate ember:heroku`
1. [Add the NodeJS buildpack][buildpack] and configure NPM to include the
   `bower` dependency's executable file.

```sh
$ heroku buildpacks:clear
$ heroku buildpacks:add --index 1 https://github.com/heroku/heroku-buildpack-nodejs
$ heroku buildpacks:add --index 2 https://github.com/heroku/heroku-buildpack-ruby
$ heroku config:set NPM_CONFIG_PRODUCTION=false
$ heroku config:unset SKIP_EMBER
```

You are ready to deploy:

```bash
$ git push heroku master
```

**NOTE** Run the generator each time you introduce additional EmberCLI
applications into the project.

[buildpack]: https://devcenter.heroku.com/articles/using-multiple-buildpacks-for-an-app#adding-a-buildpack

## Overriding the defaults

By default, routes defined by `ember_app` will be rendered with the internal
`EmberCli::EmberController`.

### Overriding the view

The `EmberCli::EmberController` renders the Ember application's `index.html` and
injects the Rails-generated CSRF tags into the `<head>`.

To customize the view, create `app/views/ember_cli/ember/index.html.erb`:

```erb
<%= render_ember_app ember_app do |head| %>
  <% head.append do %>
    <%= csrf_meta_tags %>
  <% end %>
<% end %>
```

The `ember_app` helper is available within the `EmberCli::EmberController`'s
view, and refers to the name of the current EmberCLI application.

To inject the EmberCLI generated `index.html`, use the `render_ember_app`
helper in your view:

```erb
<!-- app/views/application/index.html.erb -->
<%= render_ember_app :frontend do |head, body| %>
  <% head.append do %>
    <%= csrf_meta_tags %>
  <% end %>

  <% body.append do %>
    <%= render partial: "my-analytics" %>
  <% end %>
<% end %>
```

The `body` block argument and the corresponding call to `body.append` in the
example are both optional, and can be omitted.

### Overriding the controller

To override this behavior, you can specify [any of Rails' routing options]
[route-options].

[route-options]: http://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Base.html#method-i-match

For the sake of this example, override the `controller` and `action` options:

```rb
# config/routes

Rails.application.routes.draw do
  mount_ember_app :frontend, to: "/", controller: "application", action: "index"
end
```

When serving the EmberCLI generated `index.html` with the `render_ember_app`
helper, make sure the controller's `layout` is disabled, as EmberCLI generates a
fully-formed HTML document:

```rb
# app/controllers/application.rb
class ApplicationController < ActionController::Base
  def index
    render layout: false
  end
end
```

#### Rendering the EmberCLI generated JS and CSS

Rendering EmberCLI applications with `render_ember_app` is the recommended,
actively supported method of serving EmberCLI applications.

However, for the sake of backwards compatibility, `ember-cli-rails` supports
injecting the EmberCLI-generated assets into an existing Rails layout.

Following the example above, configure the mounted EmberCLI application to be
served by a custom controller (`ApplicationController`, in this case).

In the corresponding view, use the asset helpers:

```erb
<%= include_ember_script_tags :frontend %>
<%= include_ember_stylesheet_tags :frontend %>
```

### Mounting the Ember applications

Rendering Ember applications from routes other than `/` requires additional
configuration.

Consider a scenario where you had Ember applications named `frontend` and
`admin_panel`, served from `/` and `/admin_panel` respectively.

First, specify the Ember applications in the initializer:

```ruby
EmberCli.configure do |c|
  c.app :frontend
  c.app :admin_panel, path: "path/to/admin_ember_app"
end
```

Next, mount the applications alongside the rest of Rails' routes:

```rb
# /config/routes.rb
Rails.application.routes.draw do
  mount_ember_app :frontend, to: "/"
  mount_ember_app :admin_panel, to: "/admin_panel"
end
```

Then set each Ember application's `baseURL` to the mount point:

```javascript
// frontend/config/environment.js

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'frontend',
    environment: environment,
    baseURL: '/',
    // ...
  }
};

// path/to/admin_ember_app/config/environment.js

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'admin_panel',
    environment: environment,
    baseURL: '/admin_panel',  // originally '/'
    // ...
  }
};
```

Finally, configure EmberCLI's fingerprinting to prepend the mount point to the
application's assets:

```js
// frontend/ember-cli-build.js

module.exports = function(defaults) {
  var app = new EmberApp(defaults, {
    fingerprint: {
      // matches the `/` mount point
      prepend: 'https://cdn.example.com/',
    }
  });
};


// path/to/admin_ember_app/ember-cli-build.js

module.exports = function(defaults) {
  var app = new EmberApp(defaults, {
    fingerprint: {
      // matches the `/admin_panel` mount point
      prepend: 'https://cdn.example.com/admin_panel/',
    }
  });
};
```

When injecting the EmberCLI-generated assets with the `include_ember_script_tags`
and `include_ember_stylesheet_tags` helpers to a path other than `"/"`, a
`<base>` tag must also be injected with a corresponding `href` value:

```erb
<%= include_ember_script_tags :frontend %>
<%= include_ember_stylesheet_tags :frontend %>

<base href="/admin_panel/">
<%= include_ember_script_tags :admin_panel %>
<%= include_ember_stylesheet_tags :admin_panel %>
```

## CSRF Tokens

Your Rails controllers, by default, expect a valid authenticity token to
be submitted along with non-`GET` requests.

Without the authenticity token, requests will respond with
`422 Unprocessable Entity` errors (specifically
`ActionController::InvalidAuthenticityToken`).

To add the necessary tokens to requests, inject the `csrf_meta_tags` into
the template:

```erb
<!-- app/views/application/index.html.erb -->
<%= render_ember_app :frontend do |head| %>
  <% head.append do %>
    <%= csrf_meta_tags %>
  <% end %>
<% end %>
```

The default `EmberCli::EmberController` and the default view handle behave like
this by default.

If an Ember application is mounted with another controller, it should append
the CSRF tags to its view's `<head>`.

[ember-cli-rails-addon][addon] configures your Ember application to make HTTP
requests with the injected CSRF tokens in the `X-CSRF-TOKEN` header.

### Integrating with Rake

EmberCLI Rails exposes several useful rake tasks.

**`ember:install`**

Install the Ember applications' dependencies.

**`ember:compile`**

Compile the Ember applications.

**`ember:test`**

Execute Ember's test suite.

If you're using Rake to run the test suite, make sure to configure your test
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

## Ruby and Rails support

This project supports:

* Ruby versions `>= 2.1.0`
* Rails versions `>=4.1.x`.

To learn more about supported versions and upgrades, read the [upgrading guide].

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
