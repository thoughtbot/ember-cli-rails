0.1.5
-----

* Compilation and dependencies Rake tasks improved [#79](https://github.com/rwz/ember-cli-rails/pull/79)

0.1.4
-----

* Expose `ember-cli:compile` rake task [#73](https://github.com/rwz/ember-cli-rails/pull/73)

0.1.3
-----

* Make sure setting optional config parameters override defaults [#70](https://github.com/rwz/ember-cli-rails/issues/70)

0.1.2
-----

* Bump addon version to prevent missing tmp folder error [ember-cli-rails-addon#8](https://github.com/rondale-sc/ember-cli-rails-addon/pull/8)
* Add configuration to control Middleware and live recompilation [#64](https://github.com/rwz/ember-cli-rails/issues/64)

0.1.1
-----

* Add ember-cli:test take task [#60](https://github.com/rwz/ember-cli-rails/pull/60)

0.1.0
-----

* Expose rake task for `npm install` [#59](https://github.com/rwz/ember-cli-rails/pull/59)
* Detect and raise EmberCLI build errors [#23](https://github.com/rwz/ember-cli-rails/pull/23)

0.0.18
------

* Remove suppress jQuery feature [#49](https://github.com/rwz/ember-cli-rails/issues/49)
* Add option to manually suppress Ember dependencies [#55](https://github.com/rwz/ember-cli-rails/pull/55)

0.0.17
------

* Only precompile assets that start with <ember-app-name> [#53](https://github.com/rwz/ember-cli-rails/pull/53)

0.0.16
------

* Use local executable for ember-cli instead of global one.
  [Commit](https://github.com/rwz/ember-cli-rails/commit/4aeee53f048f0445645fbc478770417fdb66cace).
* Use `Dir.chdir` instead of passing `chdir` to `system`/`spawn`. Seems like
  JRuby doesn't yet support `chdir` option for these methods.
  Commits: [1](https://github.com/rwz/ember-cli-rails/commit/3bb149941f206153003726f1c18264dc62197f51),
           [2](https://github.com/rwz/ember-cli-rails/commit/82a39f6e523ad35ecdd595fb6e49a04cb54f9c6f).

0.0.15
------

* Fix NameError when addon version doesn't match.
  [#47](https://github.com/rwz/ember-cli-rails/pull/47)
* Fix race condition in symlink creation when run multiple workers (again).
  [#22](https://github.com/rwz/ember-cli-rails/pull/22)

0.0.14
------

* Do not include jQuery into vendor.js when jquery-rails is available.
  [#32](https://github.com/rwz/ember-cli-rails/issues/32)

0.0.13
------

* Fix assets:precompile in production environment.
  [#38](https://github.com/rwz/ember-cli-rails/issues/38)

0.0.12
------

* Make sure ember-cli-dependency-checker is present.
  [#35](https://github.com/rwz/ember-cli-rails/issues/35)

0.0.11
------

* Fix locking feature by bumping addon version to 0.0.5.
  [#31](https://github.com/rwz/ember-cli-rails/issues/31)

0.0.10
------

* Add locking feature to prevent stale code.
  [#25](https://github.com/rwz/ember-cli-rails/pull/25)

0.0.9
-----

* Fix a bug when path provided as a string, not pathname.
  [#24](https://github.com/rwz/ember-cli-rails/issues/24)

0.0.8
-----

* Add support for including Ember stylesheet link tags.
  [#21](https://github.com/rwz/ember-cli-rails/pull/21)

* Fix an error when the symlink already exists.
  [#22](https://github.com/rwz/ember-cli-rails/pull/22)

0.0.7
-----

* Add sprockets-rails to dependency list.
  [Commit](https://github.com/rwz/ember-cli-rails/commit/99a893030d6b754fe71363a396fd4515b93812b6)

* Add a flag to skip ember-cli integration.
  [#17](https://github.com/rwz/ember-cli-rails/issues/17)

0.0.6
-----

* Fix compiling assets in test environment. [#15](https://github.com/rwz/ember-cli-rails/pull/15)
* Use only development/production Ember environments. [#16](https://github.com/rwz/ember-cli-rails/pull/16)
* Make the gem compatible with ruby 1.9.3. [#20](https://github.com/rwz/ember-cli-rails/issues/20)

0.0.5
-----

* Fix generator. [Commit](https://github.com/rwz/ember-cli-rails/commit/c1bb10c6a2ec5b24d55fe69b6919fdd415fd1cdc).

0.0.4
-----

* Add assets:precompile hook. [#11](https://github.com/rwz/ember-cli-rails/issues/11)

0.0.3
-----

* Make gem Ruby 2.0 compatible. [#12](https://github.com/rwz/ember-cli-rails/issues/12)

0.0.2
-----

* Do not assume ember-cli app name is equal to configured name. [#5](https://github.com/rwz/ember-cli-rails/issues/5)
