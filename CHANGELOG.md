master
------

* Drop support for Ruby `< 2.1.0` and Rails `4.0.0, < 3.2.0`
* Introduce `include_ember_index_html` helper

0.3.5
-----

* Update addon to 0.0.12

0.3.4
-----

* Add `watcher` option

0.3.3
-----

* Support ember-cli 1.13

0.3.2
-----

* Inject `RAILS_ENV` into `ember build` process [#168][https://github.com/rwz/ember-cli-rails/pull/168]
* Explicitly register view helpers [#148](https://github.com/rwz/ember-cli-rails/pull/148)

0.3.1
-----

* Fix `assets:precompile` missing EmberCLI.compile! method

0.3.0
-----

* Add enable option to speficy what paths should have ember compiled [#145](https://github.com/rwz/ember-cli-rails/pull/145)
* Add Runner class to monitor ember deamon failures in development [#145](https://github.com/rwz/ember-cli-rails/pull/145)

0.2.3
-----

* Handle Legacy Rails' lack of acronym support [#144](https://github.com/rwz/ember-cli-rails/pull/144)

0.2.2
-----

* Don't use frozen version string in gemspec [#142](https://github.com/rwz/ember-cli-rails/pull/142)

0.2.1
-----

* Fix missing App#configuration method [#141](https://github.com/rwz/ember-cli-rails/issues/141)

0.2.0
-----

* Rename rake namespace from ember-cli to ember [commit](https://github.com/rwz/ember-cli-rails/commit/3f5463835f05d21a34b5f8a9dfeb482b0501d8d4)
* Allow helpers to take optons for ember assets [commit](https://github.com/rwz/ember-cli-rails/commit/335d117a5bf4d3520730c9c421a25aee5274c2b3)
* Make EmberCLI.skip? predicate return boolean [commit](https://github.com/rwz/ember-cli-rails/commit/6f7cd58010aaf584e0810c44568008654bd1a764)
* Introduce EmberCLI.env and ember\_cli\_rails\_mode config option [commit](https://github.com/rwz/ember-cli-rails/commit/4ff9ea1a1a152bee9f909e4379f6f469650891b5)
* Rename EmberCLI.get\_app to .app and add .[] alias [commit](https://github.com/rwz/ember-cli-rails/commit/71b4c5cc97d9a410e2ef7acc536994e5d71175c6)

0.1.13
------

* Don't Compile Assets if `SKIP_EMBER` set [#122](https://github.com/rwz/ember-cli-rails/pull/122) [@seanpdoyle](https://twitter.com/seanpdoyle)

0.1.12
------

* Fix inflector initializer for older Rails [#115](https://github.com/rwz/ember-cli-rails/pull/115) [#117](https://github.com/rwz/ember-cli-rails/pull/117)

0.1.11
------

* Do not include rake tasks twice [#110](https://github.com/rwz/ember-cli-rails/pull/110) [@BlakeWilliams](https://github.com/BlakeWilliams)

0.1.10
------

* Support ember-cli 0.2.\* [#88](https://github.com/rwz/ember-cli-rails/issues/88)

0.1.9
-----

* Only set `BUNDLE_GEMFILE` to shell environment if it exists [#92](https://github.com/rwz/ember-cli-rails/issues/92) [@seanpdoyle](https://twitter.com/seanpdoyle)
* Add Support for Rails 3.1 [#99](https://github.com/rwz/ember-cli-rails/pull/99) [@seanpdoyle](https://twitter.com/seanpdoyle)
* Use Rails' configured asset prefix in tests [#104](https://github.com/rwz/ember-cli-rails/pull/104) [@seanpdoyle](https://twitter.com/seanpdoyle)


0.1.8
-----

* Include engine file into gemspec [#91](https://github.com/rwz/ember-cli-rails/pull/91) [@jesenko](https://github.com/jesenko)

0.1.7
-----

* Serve EmberCLI tests as mountable engine [#90](https://github.com/rwz/ember-cli-rails/pull/90) [@seanpdoyle](https://github.com/seanpdoyle)

0.1.6
-----

* Support Gemfile in EmberCLI app [#84](https://github.com/rwz/ember-cli-rails/commit/652cf12c0a196b4719f6517f2fea308d8d556a5f) [@sevos](https://github.com/sevos)
* Allow relative path to be set via initializer [#72](https://github.com/rwz/ember-cli-rails/issues/74)
* Conditionally silence build output [#82](https://github.com/rwz/ember-cli-rails/issues/82)
* [DEPRECATION] Default EmberCLI application in Rails' app path [#66](https://github.com/rwz/ember-cli-rails/issues/66) [@jesenko](https://github.com/jesenko)

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
