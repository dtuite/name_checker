# NameChecker

NameChecker makes it easy to check the availability of a word across various
top-level domains and social networks.

## Installation

Add this line to your application's Gemfile:

    gem 'name_checker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install name_checker

## Usage

    availability = NameChecker.check("github", "twitter")
    availability.text
    #=> "github"
    availability.available?
    #=> false

    # NOTE: It is important to include the period at the start 
    # of the TLD when checking hosts.
    availability = NameChecker.check("availabledomain", ".net")
    availability.text
    #=> "availabledomain.net"
    availability.available?
    #=> true

## Checking Hosts

Currently this happens through the [RoboWhois API](http://www.robowhois.com/).
You will need an api key gor their service. See the configuration section of
the readme to see how to use your API key.

## Configuration

    NameChecker.config do |config|
      config.robo_whois_api_key = 'jdsfldsjflkj'
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Running the Specs

You will need to add a RoboWhois Api Key to `spec/spec_helper.rb` to be
able to run the specs. Set it up like this:

    # Add your robo whois api key here:
    ROBO_WHOIS_API_KEY = 'YOUR_KEY'
