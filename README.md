# Jsonsql

Allows you to easily execute SQL against and experiment group of JSON files.

![https://raw.github.com/siuying/jsonsql/master/jsonsql.gif](https://raw.github.com/siuying/jsonsql/master/jsonsql.gif)

## Installation

Add this line to your application's Gemfile:

    gem 'jsonsql'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jsonsql

## Usage

### File Format

jsonsql assume you have set of JSON files having identical structure. They should either be files contain one record as Hash:

```json
{
  "id": 437745519050256384,
  "text": "0825 Signal failure at West Rail Line has just resolved. Minor delay",
  "created_at": "2014-02-24 08:27:19 +0800",
  "lang": "en",
  "reply_to": null
}
```

Or files contain multiple records as Array:

```json
[
{
  "id": 437745519050256384,
  "text": "0825 Signal failure at West Rail Line has just resolved. Minor delay",
  "created_at": "2014-02-24 08:27:19 +0800",
  "lang": "en",
  "reply_to": null
},
{
  "id": 437619123200086016,
  "text": "本星期改賣「智能單程車票」的車站\n\nStations rolling out Single Journey Smart Tickets in this week： \n\nhttp://t.co/nyueEn151y  #SJST",
  "created_at": "2014-02-24 00:05:04 +0800",
  "lang": "zh",
  "reply_to": null
}
]
```

As you are importing data to a SQL database, only fields of string, number or boolean will be imported.

### Loading JSON

To use ``jsonsql``, you supply set of JSON files and optionally output file:

```
jsonsql data/*.json --save-to=output.sqlite
```

The JSON will imported to output.sqlite file.

### Console

Adding ``--console`` will open a ``pry`` console with the database as ``self``.

```
jsonsql data/*.json --console --save-to=output.sqlite
```

If you omit the ``--save-to`` option, the database will be discarded after the command.

## Contributing

1. Fork it ( https://github.com/siuying/jsonsql/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
