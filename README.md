# Ember CLI Rails

Ember CLI Rails is an integration story between (surprise suprise) Ember CLI and
Rails 3.1 and up. It is designed to provide an easy way to organize your Rails backed
Ember CLI application with a specific focus on upgradeability. Rails and Ember
[slash Ember CLI] are maintained by different teams with different goals. As
such, we believe that it is important to ensure smooth upgrading of both
aspects of your application.

A large contingent of Ember developers use Rails. And Rails is awesome. With
the upcoming changes to Ember 2.0 and the Ember community's desire to unify
around Ember CLI it is now more important than ever to ensure that Rails and
Ember CLI can coexist and development still be fun!

To this end we have created a minimum set of features (which we will outline
below) to allow you keep your Rails workflow while minimizing the risk of
upgrade pain with your Ember build tools.

For example, end-to-end tests with frameworks like Cucumber should just work.
You should still be able leverage the asset pipeline, and all the conveniences
that Rails offers. And you should get all the new goodies like ES6 modules and
Ember CLI addons too! Without further ado, let's get in there!

## Installation

Firstly, you'll have to include the gem in your `Gemfile` and `bundle install`

```ruby
gem "ember-cli-rails"
```

Then you'll want to configure your installation by adding an `ember.rb`
initializer. There is a generator to guide you, run:

```shell
rails generate ember-cli:init
```

This will generate an initializer that looks like the following:

```ruby
EmberCLI.configure do |c|
  c.app :frontend
end
```

##### options

- app - this represents the name of the Ember CLI application.

- path - the path, where your Ember CLI applications is located. The default
  value is the name of your app in the Rails root.

- enable - a lambda that accepts each requests' path. The default value is a
  lambda that returns `true`.

```ruby
EmberCLI.configure do |c|
  c.app :adminpanel # path is "<your-rails-root>/adminpanel"
  c.app :frontend,
    path: "/path/to/your/ember-cli-app/on/disk",
    enable: -> path { path.starts_with?("/app/") }
end
```

Once you've updated your initializer to taste, install Ember CLI if it is not already installed, and use it to generate your Ember CLI app in the location/s specified in the initializer. For example:

```sh
cd frontend
ember init
```

You will also need to install the [ember-cli-rails-addon](https://github.com/rondale-sc/ember-cli-rails-addon). For each of your Ember CLI applications, run:

```sh
npm install --save-dev ember-cli-rails-addon@0.0.12
```

And that's it! You should now be able to start up your Rails server and see your Ember CLI app.

### Multiple Ember CLI apps

In the initializer you may specify multiple Ember CLI apps, each of which can be
referenced with the view helper independently. You'd accomplish this like so:

```ruby
EmberCLI.configure do |c|
  c.app :frontend
  c.app :admin_panel, path: "/somewhere/else"
end
```

## Usage

You render your Ember CLI app by including the corresponding JS/CSS tags in whichever
Rails view you'd like the Ember app to appear.

For example, if you had the following Rails app

```rb
# /config/routes.rb
Rails.application.routes.draw do
  root 'application#index'
end

# /app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  def index
    render :index
  end
end
```

and if you had created an Ember app `:frontend` in your initializer, then you
could render your app at the `/` route with the following view:

```erb
<!-- /app/views/application/index.html.erb -->
<%= include_ember_script_tags :frontend %>
<%= include_ember_stylesheet_tags :frontend %>
```

Your Ember application will now be served at the `/` route.

### Other routes

Rendering Ember applications at routes other than `/` requires additional setup to avoid an Ember `UnrecognizedURLError`. 

For instance, if you had Ember applications named  `:frontend` and `:admin_panel` and you wanted to serve them at `/frontend` and `/admin_panel`, you would set up the following Rails routes:

```rb
# /config/routes.rb
Rails.application.routes.draw do
  root 'application#index'
  get  'frontend'    => 'frontend#index'
  get  'admin_panel' => 'admin_panel#index'
end

# /app/controllers/frontend_controller.rb
class FrontendController < ActionController::Base
  def index
    render :index
  end
end

# /app/controllers/admin_panel_controller.rb
class AdminPanelController < ActionController::Base
  def index
    render :index
  end
end
```

Additionally, you would have to modify each Ember app's `baseURL` to point to the correct route:

```javascript
/* /app/frontend/config/environment.js */
module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'frontend',
    environment: environment,
    baseURL: '/frontend', // originally '/'
    ...
  }
}

/* /app/admin_panel/config/environment.js */
module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'admin_panel',
    environment: environment,
    baseURL: '/admin_panel',  // originally '/'
    ...
  }
}
```
Lastly, you would configure each app's `router.js` file so that `rootURL` points to the `baseURL` you just created:

```javascript
/* app/frontend/app/router.js */
var Router = Ember.Router.extend({
  rootURL:  config.baseURL, // add this line
  location: config.locationType
});
```
Repeat for `app/admin_panel/app/router.js`. Now your Ember apps will render properly at the alternative routes.

## CSRF Tokens

Your Rails controllers, by default, are expecting a valid authenticity token to be submitted with non-`GET` requests.
Without it you'll receive a `422 Unprocessable Entity` error, specifically: `ActionController::InvalidAuthenticityToken`.

In order to add that token to your requests, you need to add into your template:

```erb
<!-- /app/views/application/index.html.erb -->
# ... your ember script and stylesheet includes ...
<%= csrf_meta_tags %>
```

This will add the tokens to your page.

You can then override the application `DS.RESTAdapter` (or whatever flavor of adapter you're using) to send that token with the requests:

```js
// path/to/your/ember-cli-app/app/adapters/application.js
import DS from 'ember-data';
import $ from 'jquery';

export default DS.RESTAdapter.extend({
  headers: {
    "X-CSRF-Token": $('meta[name="csrf-token"]').attr('content')
  }
});
```

## Ember Test Suite

To run an Ember app's tests in a browser, mount the `EmberCLI::Engine`:

```ruby
# config/routes.rb

Rails.application.routes.draw do
  mount EmberCLI::Engine => "ember-tests" if Rails.env.development?

  root "application#index"
end
```

Ember tests are served based on the route you mount the Engine on (in this
example, `/ember-tests`) and the name of the Ember app.

For example, to view tests of the `frontend` app, visit
`http://localhost:3000/ember-tests/frontend`.

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

## Integrating with `ember-cli-deploy`

The EmberCLI community recently unified the various deployment techniques into a
single, core-team supported project: [ember-cli-deploy][ember-cli-deploy].

This project attempts to streamline the process of pushing and serving
EmberCLI-built static assets.

To integrate with `ember-cli-deploy`'s ["Lightning Fast Deploys"][lightning]
(using the Redis adapter), instantiate an `EmberCLI::Deploy` in your controller:

```ruby
require "ember-cli/deploy"

class ApplicationController < ActionController::Base
  def index
    @deploy = EmberCLI::Deploy.new(namespace: "frontend")

    render text: @deploy.html, layout: false
  end
end
```

`EmberCLI::Deploy` takes a `namespace` (the name of your app declared in your
initializer) and handles all interaction with the Redis instance.

This is great for `staging` and `production` deploys, but introduces an extra
step in the feedback loop during development.

Luckily, `EmberCLI::Deploy` also accepts an `index_html` override, which will
replace the call to the Redis instance. This allows integration with the normal
`ember-cli-rails` workflow:

```ruby
require "ember-cli/deploy"

class ApplicationController < ActionController::Base
  def index
    @deploy = EmberCLI::Deploy.new(
      namespace: "frontend",
      index_html: index_html,
    )

    render text: @deploy.html, layout: false
  end

  private

  def index_html
    if serve_with_ember_cli_rails?
      render_to_string(:index)
    end
  end

  def serve_with_ember_cli_rails?
    ! %w[production staging].include?(Rails.env)
  end
end
```

Additionally, having access to the outbound HTML beforehand also enables
controllers to inject additional markup, such as metadata, CSRF tokens, or
analytics tags:


```ruby
require "ember-cli/deploy"

class ApplicationController < ActionController::Base
  def index
    @deploy = EmberCLI::Deploy.new(
      namespace: "frontend",
      index_html: index_html,
    )

    @deploy.append_to_head(render_to_string(partial: "my_csrf_and_metadata")
    @deploy.append_to_body(render_to_string(partial: "my_analytics")

    render text: @deploy.html, layout: false
  end
  # ...
end
```

[ember-cli-deploy]: https://github.com/ember-cli/ember-cli-deploy
[lightning]: https://github.com/ember-cli/ember-cli-deploy#lightning-approach-workflow

## Heroku

In order to deploy Ember CLI Rails app to Heroku:

First, enable Heroku Multi Buildpack by running the following command:

```sh
heroku buildpacks:set https://github.com/heroku/heroku-buildpack-multi
```

Next, specify which buildpacks to use by creating a `.buildpacks` file in the project root containing:

```
https://github.com/heroku/heroku-buildpack-nodejs
https://github.com/heroku/heroku-buildpack-ruby
```

Add `rails_12factor` gem to your production group in Gemfile, then run `bundle
install`:

```ruby
gem "rails_12factor", group: :production
```

Add a `package.json` file containing `{}` to the root of your Rails project.
This is to make sure it'll be detected by the NodeJS buildpack.

Make sure you have `bower` as a npm dependency of your ember-cli app.

Add a `postinstall` task to your Ember CLI app's `package.json`. This will
ensure that during the deployment process, Heroku will install all dependencies
found in both `node_modules` and `bower_components`.

```javascript
{
  # ...
  "scripts": {
    # ...
    "postinstall": "node_modules/bower/bin/bower install"¬
  }
}
```

ember-cli-rails adds your ember apps' build process to the rails asset compilation process.

Now you should be ready to deploy.

## Experiencing Slow Build/Deploy Times?
Remove `ember-cli-uglify` from your `package.json` file, and run
`npm remove ember-cli-uglify`. This will improve your build/deploy
time by about 10 minutes.

The reason build/deploy times were slow is because ember uglified the JS and
then added the files to the asset pipeline. Rails would then try and uglify
the JS again, and this would be considerable slower than normal.

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
EmberCLI.configure do |c|
  c.app :frontend, exclude_ember_deps: "jquery"
  c.app :admin_panel, exclude_ember_deps: ["jquery", "handlebars"]
end
```

jQuery and Handlebars are the main use cases for this flag.

## Contributing

1. Fork it (https://github.com/rwz/ember-cli-rails/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
