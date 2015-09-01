# require_callbacks

This gem gives you convenient hooks around calls to `load`, `require`, and `require_relative`,
which can be used to define configuration or setup code that will eventually be run when the
library is actually loaded. This helps prevent loading unnecessary gems and configuration code in
contexts where they are not needed.

## Basic Example

If you are using bundler, you may be loading gems automatically. To prevent this behavior,
add `require: false` in your `Gemfile` like so:

```ruby
gem 'inky', '~> 1.6.0', require: false

# Alternatively, you can replace `Bundler.require` with `Bundler.setup`
```

Then, in your application's initialization code (or wherever most of your configuration code goes),
define the block that must be run after the gem is loaded:

```ruby
after_require('inky') do
  Inky.authorize!(ENV['MY_INKY_KEY']) }
end
```

Lastly, wherever you ultimately need to use the gem, make sure to `require` it at the top of the
file:

```ruby
require 'inky'
```

And that's it! As long as `after_require` gets called before `require`, you're good to go.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'require_callbacks', require: false
```

And this line before you define your callbacks:
```ruby
require 'require_callbacks'

# Or, alternatively, don't include the "require: false" for this gem in your Gemfile ;-)
```

Lastly, don't forget to execute:

    $ bundle

## Callbacks

`require_callbacks` adds the following methods, which are wrapped around `load`, `require`, and
`require_relative` (respectively). Note that the `after_require` callbacks will only be run the
*first* time (when `require` returns true), while `after_load` and all `before_` callbacks will
be run *every* time.

```ruby
after_load('myfile.rb') do
  # always run
end
after_require('mygem') do
  # run once
end
after_require_relative('./myfile') do
  # run once
end

before_load('myfile.rb') do
  # always run
end
before_require('mygem') do
  # always run
end
before_require_relative('./myfile') do
  # always run
end
```

## Warnings

This gem messes with standard `Kernal` methods, so use at your own risk! There may be compatibility
issues with anything else that modifies `load`, `require`, and `require_relative`.

## Contributing

1. Fork it ( https://github.com/smudge/require_callbacks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
