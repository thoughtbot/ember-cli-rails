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
