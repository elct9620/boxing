# Boxing

The zero-configuration Dockerfile generator for Ruby.

> The [Database Repository](https://github.com/elct9620/ruby-boxing-db) will be used for package information.

## Installation

Add this line to your application's Gemfile development group:

```ruby
group :development do
  gem 'boxing'
end
```

And then execute:

    $ bundle install

## Features

### Automatic Package Finder

This gem will read `Gemfile` and find any "knows" gem in the dependency database and put the necessary package as a dependency for build and runtime.

That means you never need to know the actual package and don't need to write your Dockerfile by hand.

### Optimized Size

By the default, the base image is depend on `ruby:[VERSION]-alpine` which is minimal size for Ruby in most cases.

To let your image as small as possible, this gem uses multi-stage and strip useless artifacts while the c-extension compiling.

The final Rails image will be around 100MB and can be flexible to delivery to any environment.

> We suggest using `puma` as the webserver to avoid the extra dependency to keep the image small.

### Revision

To identity your image version, the default build argument `REVISION` will be configured by default.

You can add extra options when you are building images in your CI.

```yaml
# GitLab CI example
docker:rails:
  extends: .docker
  stage: package
  script:
    - docker build
      --cache-from $RAILS_IMAGE:latest
      --build-arg REVISION=${CI_COMMIT_SHORT_SHA}
      --build-arg BUILDKIT_INLINE_CACHE=1
      --tag $RAILS_IMAGE:$CI_COMMIT_REF_SLUG
      --tag $RAILS_IMAGE:latest .
```

It will helpful for Sentry to detect the released version or use `<%= ENV['REVISION'] %>` to help you identify the current version.

## Usage

### Generate

To generate `Dockerfile` for current project

```ruby
bundle exec boxing generate
```

### Update

To update the database for package information

```ruby
bundle exec boxing update
```

> If the generated `Dockerfile` is not satisfy, please try to update it.

### Configuration

If `config/boxing.rb` is found, it will be loaded and change the generated `Dockerfile` and `.dockerignore`

```ruby
Boxing.config do |c|
 c.root = '/var/www'
end
```

## Roadmap

* [x] `Dockerfile` generator
* [x] `.dockerignore` generator
  * [x] Common ignore files
  * [ ] Customizable ignore files
* [x] Customize config file `config/boxing.rb`
  * [x] Customize `APP_ROOT`
  * [ ] Extra packages
  * [ ] DSL to customize `Dockerfile`
    * [ ] Build Stage
    * [ ] Entrypoint
    * [ ] Command
    * [ ] Expose Port
* [ ] Entrypoint Detection
  * [x] Openbox (Suggested)
  * [x] Ruby on Rails
  * [ ] Rack
  * [ ] Ruby
* [ ] Package Database
  * [x] Built-in (Move to standalone repoistory in future)
  * [x] Standalone Repoistory
  * [x] Support gems from `git` repoistory
  * [x] Customize Source
  * [ ] Base Image
    * [x] Alpine
    * [ ] Ubuntu
  * [ ] Filter by Ruby Version
  * [ ] Filter by Gem Version

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/elct9620/boxing. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/elct9620/boxing/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the Boxing project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/elct9620/boxing/blob/main/CODE_OF_CONDUCT.md).
