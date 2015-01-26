# EmberCLI Rails

EmberCLI Rails is an integration story between (surprise suprise) EmberCLI and
Rails. It is designed to provide an easy way to organize your Rails backed
EmberCLI application with a specific focus on upgradeability. Rails and Ember
[slash EmberCLI] are maintained by different teams with different goals. As
such, we believe that it is important to ensure smooth upgrading of both
aspects of your application.

A large contingent of Ember developers use Rails. And Rails is awesome. With
the upcoming changes to Ember 2.0 and the Ember community's desire to unify
around EmberCLI it is now more important than ever to ensure that Rails and
EmberCLI can coexist and development still be fun!

To this end we have created a minimum set of features (which we will outline
below) to allow you keep your Rails workflow while minimizing the risk of
upgrade pain with your Ember build tools.

For example, end-to-end tests with frameworks like Cucumber should just work.
You should still be able leverage the asset pipeline, and all the conveniences
that Rails offers. And you should get all the new goodies like ES6 modules and
EmberCLI addons too! Without further ado, let's get in there!

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

- app - this represents the name of the ember cli application.  The presumed
  path of which would be `Rails.root.join('app', <your-appname>)`

- path - used if you need to override the default path (mentioned above).
  Example usage:

```ruby
EmberCLI.configure do |c|
  c.app :frontend, path: "/path/to/your/ember-cli-app/on/disk"
end
```

Once you've updated your initializer to taste, you need to install the
[ember-cli-rails-addon](https://github.com/rondale-sc/ember-cli-rails-addon).

For each of your EmberCLI applications install the addon with:

```sh
npm install --save-dev ember-cli-rails-addon@0.0.11
```

And that's it!

### Multiple EmberCLI apps

In the initializer you may specify multiple EmberCLI apps, each of which can be
referenced with the view helper independently. You'd accomplish this like so:

```ruby
EmberCLI.configure do |c|
  c.app :frontend
  c.app :admin_panel, path: "/somewhere/else"
end
```

## Usage

You render your EmberCLI app by including the corresponding JS/CSS tags in whichever
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

## Enabling LiveReload

In order to get LiveReload up and running with EmberCLI Rails, you can install
[guard](https://github.com/guard/guard) and
[guard-livereload](https://github.com/guard/guard-livereload) gems, run `guard
init` and then add the following to your `Guardfile`.

```ruby
guard "livereload" do
  # ...
  watch %r{app/<your-appname>/app/\w+/.+\.(js|hbs|html|css|<other-extensions>)}
  # ...
end
```

This tells Guard to watch your EmberCLI app for any changes to the JavaScript,
Handlebars, HTML, or CSS files within `app` path. Take note that other
extensions can be added to the line (such as `coffee` for CoffeeScript) to
watch them for changes as well.

## Heroku

In order to deploy EmberCLI Rails app to Heroku you need to follow the steps
below:

First, enable Heroku Multi Buildpack by running the following command:

```sh
heroku config:add BUILDPACK_URL=https://github.com/heroku/heroku-buildpack-multi
```

Next, check in `.buildpacks` file to specify which buildpacks to use:

```
https://github.com/heroku/heroku-buildpack-nodejs
https://github.com/heroku/heroku-buildpack-ruby
```

Add `rails_12factor` gem to your production group in Gemfile, then run `bundle
install`:

```ruby
gem "rails_12factor", group: :production
```

Add a `package.json` to the root of your Rails project. This is to make sure
it'll be detected by the NodeJS buildpack.

```javascript
{
  "dependencies": {
    "bower": "*"
  }
}
```

Add a `postinstall` task to your EmberCLI app's `package.json`. This will
ensure that during the deployment process, Heroku will install all dependencies
found in both `node_modules` and `bower_components`.

```javascript
{
  # ...
  "scripts": {
    # ...
    "postinstall": "../../node_modules/bower/bin/bower install"
  }
}
```

Now you should be ready to deploy.

## Additional Information

When running in the development environment, EmberCLI Rails runs `ember build`
with the `--output-path` and `--watch` flags on. The `--watch` flag tells
EmberCLI to watch for file system events and rebuild when an EmberCLI file is
changed. The `--output-path` flag specifies where the distribution files will
be put. EmberCLI Rails does some fancy stuff to get it into your asset path
without polluting your git history. Note that for this to work, you must have
`config.consider_all_requests_local = true` set in
`config/environments/development.rb`, otherwise the middleware responsible for
building EmberCLI will not be enabled.

Alternatively, if you want to override the default behavior in any given Rails
environment, you can manually set the `config.use_ember_middleware` and
`config.use_ember_live_recompilation` flags in the environment-specific config
file.

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
