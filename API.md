# API Documentation #

Mete responds to several requests.
The API is REST-like (but not entirely).

For each of these endpoints there's one without the suffix `.json`,
but it returns an unspecified HTML rendering of the data.
This can change at any time - do not parse it!

Some of these things can be put into a hash. For example:
You can pass these parameters to `/drinks.json`:
 * `drink[name]=Mate`
 * `drink[price]=1.5`

Or you can pass these parameters:
 * `name=Mate`
 * `price=1.5`

## / ##

 * `GET /` - the same as `GET /users.json`

### /audits ###

 * `GET /audits.json` - returns statistics about previous transactions; possible paramters are:
   * `start_date[year]` - `integer`
   * `start_date[month]` - `integer`
   * `start_date[day]` - `integer`
   * `end_date[year]` - `integer`
   * `end_date[month]` - `integer`
   * `end_date[day]` - `integer`

### /drinks ###

 * `GET /drinks.json` - returns all drinks
 * `GET /drinks/%did%.json` - returns information about the drink with the id `%did%`
 * `GET /drinks/new.json` - returns the default values for creating a new drink
 * `POST /drinks.json` - creates a new drink; parameters are: (all parameters can be attributes of `drink`)
   * `name` - `string` - the name of the new drink
   * `price` - `double` - the price of the new drink in €
   * `bottle_size` - `double` - the bottle size of the new drink in l
   * `caffeine` - `integer` - the amount of caffeine of the new drink in mg/100ml
   * `active` - `boolean` - whether the new drink is in stock
   * `logo` - `file` - the logo of the new drink
 * `PATCH /drinks/%did%.json` - modifys an existing drink; the parameters are the same as for creating a new drink
 * `DELETE /drinks/%did%.json` - deletes the drink with the id `%did%`

### /users ###

 * `GET /users.json` - returns all users
 * `GET /users/%uid%.json` - returns information about the user with the id `%uid%`
 * `GET /users/new.json` - returns the default values for creating a new user
 * `POST /users.json` - creates a new user; parameters are: (all parameters can be attributes of `user`)
   * `name` - `string` - the name of the new user
   * `email` - `string` - the email of the new user
   * `balance`- `double` - the balance of the new user in €
   * `active` - `boolean` - whether the new user is active
 * `PATCH /users/%uid%.json` - modifys an existing user; the parameters are the same as for adding a user
 * `DELETE /users/%uid%.json` - deletes the user with the id `%uid%`
 * `GET /users/%uid%/deposit.json?amount=%amount%` - adds the amount `%amount%` (in €) to the balance of the user with the id `%uid%` (**This GET request modifys data!**)
 * `GET /users/%uid%/pay.json?amount=%amount%` - removes the amount `%amount%` (in €) from the balance of the user with the id `%uid%` (**This GET request modifys data!**)
 * `GET /users/%uid%/buy.json?drink=%did%` - buys the drink with the id `%did%` for the user with the id `%uid%` (**This GET request modifys data!**)
 * `POST /users/%uid%/buy_barcode.json` - buys the drink with the barcode `%barcode%` for the user with the id `%uid`
 * `GET /users/stats.json` - displays various statistics about the users

### /barcodes ###

 * `GET /barcodes.json` - returns all barcodes
 * `GET /barcodes/new.json` - returns the defaults for creating new barcodes
 * `POST /barcodes.json` - creates a new barcode; parameters are: (all parameters can be attributes of `barcode`)
   * `id` - `string` - the barcode
   * `drink` - `int` - the ID of the drink
 * `DELETE /barcodes/%id%.json` - deletes the barcode with the id `%id%`
