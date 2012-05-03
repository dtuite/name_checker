# NameChecker

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'name_checker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install name_checker

## Usage

```
availability = NameChecker.check("github", "twitter")
availability.text
#=> "github"
availability.available?
#=> false

availability = NameChecker.check("availabledomain", "net")
availability.text
#=> "availabledomain.net"
availability.available?
#=> true
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
