[![Code Climate](https://codeclimate.com/github/awkisopen/australium.png)](https://codeclimate.com/github/awkisopen/australium)
# Australium

<img src="http://i.imgur.com/IpOgnjO.png" align="right" />
Australium is a powerful TF2 game log parser. It allows access to all game events and player data in a hierarchical,
rubyified manner. The timestamp and state of the game are stored within every event for easy access.

<br clear="all" />

## Installation

Add this line to your application's Gemfile:

    gem 'australium'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install australium

## Example Usage

```ruby
require 'australium'

# Load game data from logfile
games = Australium::parse_file('/tmp/tf2game.log')

# Logfiles may contain multiple games, but chances are good your logfile will only have one.
game = games.first

# Print the name of each player and the team they were on.
game.players.each do |player|
  puts "#{p.nick} - #{p.team.empty? ? 'None' : p.team}"
end

# Count the number of backstabs that took place during the game.
puts 'Backstabs: ' + game.kills.select { |e| e.customkill == 'backstab' }.count.to_s
```

Check [the documentation](http://rubydoc.info/github/awkisopen/australium/master/frames) for more information on how to access game events.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
