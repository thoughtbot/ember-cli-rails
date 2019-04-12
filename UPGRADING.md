# Ruby support

According to [these release notes][latest-eol], Ruby versions prior to `2.5.x`
has been end-of-lifed.

Additionally, this codebase makes use of [(required) keyword arguments][kwargs].

From `ember-cli-rails@0.4.0` and on, we will no longer support versions of Ruby
prior to `2.1.0`.

`ember-cli-rails@0.8.0` adds support for Rails 5, which depends on `rack@2.0.x`,
which **requires** Ruby `2.2.2` or greater.

From `ember-cli-rails@0.8.0` and on, we will no longer support versions of Ruby
prior to `2.2.2`.

From `ember-cli-rails@0.12.0` and on, we will no longer support versions of Ruby
prior to `2.5.x`.

To use `ember-cli-rails` with older versions of Ruby, try the `0.3.x` series.

[kwargs]: https://robots.thoughtbot.com/ruby-2-keyword-arguments
[latest-eol]: https://www.ruby-lang.org/en/news/2020/04/05/support-of-ruby-2-4-has-ended/

# Rails support

According to the [Rails Maintenance Policy][version-policy], Rails versions
prior to `5.2.x` have been end-of-lifed. Additionally, the `4.0.x` series no
longer receives bug fixes of any sort.

From `ember-cli-rails@0.4.0` and on, we will no longer support versions of Rails
prior to `3.2.0`, nor will we support the `4.0.x` series of releases.

To use `ember-cli-rails` with older versions of Rails, try the `0.3.x` series.

[version-policy]: http://guides.rubyonrails.org/maintenance_policy.html
