# Bible

TODO: Write a gem description

## Installation

Dependencies:

```
# Note that this might already be provided by the system os
brew install sqlite
```

## Usage

To run during development, you will need to inlcude the lib folder at runtime.

```
mkdir ~/.bibles
ruby -I lib bin/bible install ~/Downloads/bible-xml-to-csv/nasb.csv nasb1995
ruby -I lib bin/bible read nasb1995
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/bible/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
