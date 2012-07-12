# NameChecker [![Build Status](https://secure.travis-ci.org/dtuite/name_checker.png?branch=master)](http://travis-ci.org/dtuite/name_checker)

NameChecker makes it easy to check the availability of a word across various
top-level domains and social networks. 

It powers checking at [namedar.com](http://namedar.com).

 - [RubyDocs](http://www.rubydoc.info/github/dtuite/name_checker/master/frames)

## Installation

Add this line to your application's Gemfile:

    gem 'name_checker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install name_checker

## API

    availability = NameChecker.check(<WORD>, <SERVICE>)

## Usage

    availability = NameChecker.check("banana", "twitter")
    availability.text
    #=> "banana"
    availability.available?
    #=> false

    # NOTE: It is important to include the period at the start 
    # of the TLD when checking hosts.
    availability = NameChecker.check("availabledomain", ".net")
    availability.text
    #=> "availabledomain.net"
    availability.available?
    #=> true

## Supported Social Networks

 - Facebook
 - Twitter

## Supported Top-level Domains

 See the documentation of the [Ruby-Whois Gem](http://www.ruby-whois.org/).

## Checking Domain Availability

Domain availability checking can occur either with the [Whois Gem](http://bit.ly/KYquaW)
(default) or via the [RoboWhois API](http://bit.ly/KYqveX).

To use the RoboWhois service, simply configure NameChecker with an API key.

    NameChecker.config do |config|
      config.robo_whois_api_key = 'jdsfldsjflkj'
    end

All domain availability requests will then route through RoboWhois.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Running the Specs

You will need to add a RoboWhois Api Key to `spec/spec_helper.rb` to be
able to run all of the specs. Set it up like this:

    # Add your robo whois api key here:
    ROBO_WHOIS_API_KEY = 'YOUR_KEY'

You can still run the specs without an API key. However, all specs related
to the RoboWhoisChecker will fail.
