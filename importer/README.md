## Data Importer

This app accepts a TAB delimited file with your data and will normalize
and add the data to SQLite (a simple, lightweight relational database).

The TAB delimited file must have, in this order, all the following columns:

    purchaser name
    item description
    item price
    purchase count
    merchant address
    merchant name

There must be a header line, with all these fields and all rows and
columns must have data.


### System Requirements

In order to run the app locally, you must have the following software
installed:

* [Ruby][] v1.9.3
* [RubyGems][] v1.8.23
* [SQLite][] v3.7.12
* [Rails][] v4.0.4


### Setting Up

Once you have the necessary dependencies installed, you can use the
following commands to interact with the application.

To run the tests, type:

    rake spec

To start the server and use the web app:

    rake importer:start

This will start the rails server and the necessary background service to
enable the app to work properly.  To use it, just open your browser and
go to `http://localhost:3000`.


[ruby]: https://www.ruby-lang.org/en/
  "Ruby website"
[rubygems]: https://rubygems.org/
  "RubyGems website"
[sqlite]: https://sqlite.org/
  "SQLite website"
[rails]: http://rubyonrails.org/
  "Ruby on Rails website"
