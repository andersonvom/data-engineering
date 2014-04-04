## Data Importer

This app accepts a TAB delimited file with your data and will normalize
and add the data to [SQLite][] (a simple, lightweight relational database).

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

* Ruby v1.9.3
* SQLite v3.7.12



### To be continued...

* Configuration
* Database creation
* Database initialization
* How to run the test suite
* Services (job queues, cache servers, search engines, etc.)
* Deployment instructions
* ...


Please feel free to use a different markup language if you do not plan to run
`rake doc:app`.


[sqlite]: https://sqlite.org/
  "SQLite website"
