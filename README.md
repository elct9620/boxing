# Boxing

The zero-configuration Dockerfile generator for Ruby.

## Installation

Add this line to your application's Gemfile development group:

```ruby
group :development do
  gem 'boxing'
end
```

And then execute:

    $ bundle install

## Usage

### Generate

To generate `Dockerfile` for current project

```ruby
bundle exec boxing generate
```

## Roadmap

* [x] `Dockerfile` generator
* [ ] Customize config file `config/boxing.rb`
* [ ] Entrypoint Detection
  * [x] Openbox (Suggested)
  * [x] Ruby on Rails
  * [ ] Rack
  * [ ] Ruby
* [ ] Package Database
  * [x] Built-in (Move to standalone repoistory in future)
  * [ ] Standalone Repoistory
  * [ ] Customize Source
  * [ ] Base Image
    * [x] Alpine
    * [ ] Ubuntu
  * [ ] Ruby Version

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/elct9620/boxing. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/elct9620/boxing/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the Boxing project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/elct9620/boxing/blob/main/CODE_OF_CONDUCT.md).
