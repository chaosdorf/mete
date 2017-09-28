# API Documentation #

Mete currently implements [version 1](https://space-market.github.io/API/preview/v1/) of the [Space-Market API](https://github.com/Space-Market/API).

The API endpoint is currently located at `/api/v1`.
In older versions of Mete, this was located at `/`.
Some installations may have not yet been upgraded. Please be prepared.
Some already upgraded installations may provide legacy support at `/`,
but please don't depend on this.
If you want to setup those for your own installation, please take a look at
 [`v1-rewrite.md`](https://github.com/chaosdorf/mete/blob/master/v1-rewrite.md).
(Implementing upcoming versions of the specification would be great, too.)

For each of these endpoints there's one without the suffix `.json` located at `/`,
but it returns an unspecified HTML rendering of the data.
This can change at any time - do not parse it!

Some of these things can be put into a hash. For example:
You can pass these parameters to `/drinks.json`:
 * `drink[name]=Mate`
 * `drink[price]=1.5`

Or you can pass these parameters:
 * `name=Mate`
 * `price=1.5`

These are the endpoints which Mete supports,
but are not (yet) part of the specification or have additional parameters:

 * `POST /users/%uid%/buy_barcode.json` - buys the drink with the barcode `%barcode%` for the user with the id `%id%`
