# HidApi

HidApi is an FFI wrapper around the C library '[hidapi][1]' provided by Signal11.

[1]: http://www.signal11.us/oss/hidapi/

This gem is my first attempt at writing any FFI code, and my first attempt to use USB. It's very possible that conventions will be broken, edge cases missed and that nothing will work if you're not using it exactly how I am. But let me know (open a Github issue, or even better see the Contributing section below) and I might be able to do something about it.

## Dependencies

The gem requires the hidapi library to be installed and available to Ruby. On Mac with homebrew installed, this can be done with the command:

### For macOS

    $ brew install hidapi

### For Debian

    $ sudo apt install libhidapi-dev libhidapi-hidraw0 libhidapi-libusb0

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hid_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hid_api

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/gareth/ruby_hid_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
