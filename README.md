# Jsonsql

Allows you to easily execute SQL against and experiment group of JSON files.

[](https://raw.github.com/siuying/jsonsql/master/jsonsql.gif)

## Installation

Add this line to your application's Gemfile:

    gem 'jsonsql'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jsonsql

## Usage

jsonsql assume you have set of JSON files having identical structure. To use it, you supply set of JSON files to jsonsql:

```
jsonsql data/*.json --save-to=output.sqlite
```

The JSON will imported to output.sqlite file.

Adding ``--console`` will open a ``pry`` console with the database as ``self``.

```
jsonsql data/*.json --console --save-to=output.sqlite
```

If you omit the ``--save-to`` option, the database will be discarded after the command.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/jsonsql/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
