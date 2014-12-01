# EmberCLI Rails

EmberCLI Rails is an integration story between (surprise suprise) EmberCLI and Rails.  It is designed to provide an easy way to organize your Rails backed EmberCLI application with a specific focus on upgradeability.  Rails and Ember [slash EmberCLI] are maintained by different teams with different goals.  As such, we believe that it is important to ensure smooth upgrading of both aspects of your application.

A large contingent of Ember developers use Rails.  And Rails is awesome.  With the upcoming changes to Ember 2.0 and the Ember community's desire to unify around EmberCLI it is now more important than ever to ensure that Rails and EmberCLI can coexist and development still be fun!

To this end we have created a minimum set of features (which we will outline below) to allow you keep your Rails workflow while minimizing the risk of upgrade pain with your Ember build tools.

For example, end-to-end tests with frameworks like Cucumber should just work.  You should still be able leverage the asset pipeline, and all the conveniences that Rails offers.  And you should get all the new goodies like ES6 modules and EmberCLI addons too!  Without further ado, let's get in there!

## Installation

Firstly, you'll have to include the gem in your `Gemfile` and `bundle install`

```ruby
gem 'ember-cli-rails'
```

Then you'll want to configure your installation by adding an `ember.rb` initializer.  There is a generator to guide you, run:

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

- app - this represents the name of the ember cli application.  The presumed path of which would be `Rails.root.join('app', <your-appname>)`

- path - used if you need to override the default path (mentioned above) Example usage:

```ruby
EmberCLI.configure do |c|
  c.app :frontend, path: "/path/to/your/ember-cli-app/on/disk"
end
```

Once you've updated your initializer to taste, you need to tell EmberCLI that you want the meta tag to be served in your javascript.  Open up your `Brocfile` inside your EmberCLI app and add `{storeConfigInMeta: false}`.

It should look something like this (if you've left it unchanged):

```javascript
var EmberApp = require('ember-cli/lib/broccoli/ember-app');

var app = new EmberApp({storeConfigInMeta: false});

// etc...
```

And that's it!

### Multiple EmberCLI apps

In the initializer you may specify multiple EmberCLI apps, each of which can be referenced with the view helper independently.  You'd accomplish this like so:

```ruby
EmberCLI.configure do |c|
  c.app :frontend
  c.app :admin_panel, path: '/somewhere/else'
end
```

## Usage

In order to load your EmberCLI generated app you need only include the javscript tags on the page you'd like the Ember app to appear:

```erb
<%= ember_cli_script_tags :frontend %>
```

Your Ember application will be served now.

## Additional Information

EmberCLI Rails runs `ember build` with the `--output-path` and `--watch` flags on.  The `--watch` flag sets tells EmberCLI to watch for file system events and rebuild when an EmberCLI file is changed.  The `--output-path` flag specifies where the distribution files will be put.  EmberCLI Rails does some fancy stuff to get it into your asset path without polluting your git history.

## Contributing

1. Fork it (https://github.com/rwz/ember-cli-rails/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
