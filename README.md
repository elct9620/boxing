Boxing
===
[![Ruby](https://github.com/elct9620/boxing/actions/workflows/main.yml/badge.svg)](https://github.com/elct9620/boxing/actions/workflows/main.yml)

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

### Bootsnap Precompile (Experimental)

If your gem dependency included `bootsnap` the generated Dockerfile will add precompile options to speed up the application bootstrap.

### AWS Lambda Runtime Interface Client

When the `aws_lambda_ric` gem is detected, the `boxing` will choose to use `bin/aws_lambda_ric` as entrypoint.

To make it works correctly, run `bundle binstub aws_lambda_ric` to make it can run it correctly.

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

## Configuration

If `config/boxing.rb` is found, it will be loaded and change the generated `Dockerfile` and `.dockerignore`

### Source Code Root

```ruby
Boxing.config do |c|
  c.root = '/var/www'
end
```

### Customize Entrypoint

```ruby
Boxing.config do |c|
  c.entrypoint = ['bin/rails']
end
```

### Customize Command

```ruby
Boxing.config do |c|
  c.command = ['server', '-b', '127.0.0.1']
end
```

### Ignore Files

```ruby
Boxing.config do |c|
  c.ignores = %w[
    vendor/gems
  ]
end
```

### Extra Packages

```ruby
Boxing.config do |c|
  c.build_packages = %w[nodejs]
  c.runtime_packages = %w[git]
end
```

### Revision Information

```ruby
Boxing.config do |c|
  c.revision = true
end
```
> When building the image, you have to add `--build-arg REVISION=...` to set your revision name to compile it correctly.

### Sentry Support

```ruby
Boxing.config do |c|
  c.sentry_release = true
end
```
> When building the image, you have to add `--build-arg SENTRY_RELEASE=...` to set your release name to compile it correctly.

### Assets Precompile

This feature is disabled by default and suggest to use CI to build it.

```ruby
Boxing.config do |c|
  c.assets_precompile = true
  # If not given the `node -v` will be execute
  c.node_version = '14.18'
end
```
> When building the image, you have to add `--build-arg RAILS_MASTER_KEY=...` to set your production key to compile it correctly.

### Health Check

```ruby
Boxing.config do |c|
  c.health_check = true
  c.health_check_path = '/api/status.json'
end
```

> If `liveness` gem is installed, the health check will enabled by default with `/status` path.

## Roadmap

* [x] `Dockerfile` generator
* [x] `.dockerignore` generator
  * [x] Common ignore files
  * [x] Customizable ignore files
* [ ] Docker Compose generator
  * [ ] Production Version
  * [x] Development Version
* [x] Allow run Assets Precompile in Container
  * [ ] Disable `RAILS_SERVE_STATIC_FILES` by default
* [x] Customize config file `config/boxing.rb`
  * [x] Customize `APP_ROOT`
  * [x] Extra packages
  * [ ] DSL to customize `Dockerfile`
    * [ ] Build Stage
    * [x] Entrypoint
    * [x] Command
    * [x] Expose Port
* [x] Health Check
  * [x] [Liveness](https://github.com/elct9620/openbox) gem detection
  * [x] Add `curl` for web application
* [x] Entrypoint Detection
  * [x] [Openbox](https://github.com/elct9620/openbox) (Suggested)
  * [x] Ruby on Rails
  * [x] Rack (Default)
  * [x] AWS Lambda Runtime Interface Client
    * [x] Lamby supported (Default)
    * [x] SQS ActiveJob Lambda Handler
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
