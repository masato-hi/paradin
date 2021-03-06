# Paradin

Multi thread processing wrapper library for Ruby (Rails supported)

![test](https://github.com/masato-hi/paradin/workflows/test/badge.svg)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paradin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paradin

## Usage

```
class ParallelTask < Paradin::Base
  timeout 5
  max_threads 3

  def perform(x, y)
    sleep 1
    x + y
  end
end

task = ParallelTask.new
5.times do |i|
  task.enqueue(i, i)
end

# Response in 2 seconds
task.await #=> [0, 2, 4, 6, 8]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/masato-hi/paradin.
