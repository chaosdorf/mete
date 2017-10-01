# API Documentation #

Mete responds to several requests.
The API is REST-like (but not entirely).

## / ##

 * `GET /` - the same as `GET /users`

### /audits ###

 * `GET /audits` - returns statistics about previous transactions; possible paramters are:
   * `start_date[year]` - `integer`
   * `start_date[month]` - `integer`
   * `start_date[day]` - `integer`
   * `end_date[year]` - `integer`
   * `end_date[month]` - `integer`
   * `end_date[day]` - `integer`
 * `GET /audits.json` - the same as above, but in JSON format

### /drinks ###

 * `GET /drinks` - returns all drinks
 * `GET /drinks.json` - the same as above, but in JSON format
 * `GET /drinks/%did%` - returns information about the drink with the id `%did%`
 * `GET /drinks/%did%.json` - the same as above, but in JSON format
 * `GET /drinks/new` - displays a form for creating a new drink
 * `GET /drinks/new.json` - wat. This makes no sense.
 * `POST /drinks` - creates a new drink; parameters are:
   * `drink[name]` - `string` - the name of the new drink
   * `drink[price]` - `double` - the price of the new drink in €
   * `drink[bottle_size]` - `double` - the bottle size of the new drink in l
   * `drink[caffeine]` - `integer` - the amount of caffeine of the new drink in mg/100ml
   * `drink[active]` - `boolean` - whether the new drink is in stock
   * `drink[logo]` - `file` - the logo of the new drink
 * `POST /drinks.json` - the same as above, but in JSON format (What's the difference?)
 * `GET /drinks/%did%/edit` - displays a form for editing an existing drink
 * `PATCH /drinks/%did%` - modifys an existing drink; the parameters are the same as for creating a new drink
 * `PATCH /drinks/%did%.json` - the same as above, but in JSON format (What's the difference?)
 * `DELETE /drinks/%did%` - deletes the drink with the id `%did%`
 * `DELETE /drinks/%id.json` - the same as above, but in JSON format (What's the difference?)

### /users ###

 * `GET /users` - returns all users
 * `GET /users.json` - the same as above, but in JSON format
 * `GET /users/%uid%` - returns information about the user with the id `%uid%`
 * `GET /users/%uid%.json` - the same as above, but in JSON format
 * `GET /users/new` - displays a form for creating a new user
 * `GET /users/new.json` - wat. This makes no sense.
 * `POST /users` - creates a new user; parameters are:
   * `user[name]` - `string` - the name of the new user
   * `user[email]` - `string` - the email of the new user
   * `user[balance]`- `double` - the balance of the new user in €
   * `user[active]` - `boolean` - whether the new user is active
 * `POST /users.json` - the same as above, but in JSON format (What's the difference?)
 * `GET /users/edit` - display a form for editing an existing user
 * `PATCH /users/%uid%` - modifys an existing user; the parameters are the same as for adding a user
 * `PATCH /users/%uid%.json` - the same as above, but in JSON format (What's the difference?)
 * `DELETE /users/%uid%` - deletes the user with the id `%uid%`
 * `DELETE /users/%uid%.json` - the same as above, but in JSON format (What's the difference?)
 * `GET /users/%uid%/deposit?amount=%amount%` - adds the amount `%amount%` (in €) to the balance of the user with the id `%uid%` (**This GET request modifys data!**)
 * `GET /users/%uid%/deposit.json?amount%amount%` - the same as above, but in JSON format (What's the difference?) (**This GET request modifys data!**)
 * `GET /users/%uid%/pay?amount=%amount%` - removes the amount `%amount%` (in €) from the balance of the user with the id `%uid%` (**This GET request modifys data!**)
 * `GET /users/%uid%/pay.json?amount%amount%` - the same as above, but in JSON format (What's the difference?) (**This GET request modifys data!**)
 * `GET /users/%uid%/buy?drink=%did%` - buys the drink with the id `%did%` for the user with the id `%uid%` (**This GET request modifys data!**)
 * `GET /Users/%uid%/buy.json?drink=%did%` - the same as above, but in JSON format (What's the difference?) (**This GET request modifys data!**)
 * `POST /users/%uid%/buy_barcode` - buys the drink with the barcode `%barcode%` for the user with the id `%uid`
 * `POST /users/%uid%/buy_barcode.json` - buys the drink with the barcode `%barcode%` for the user with the id `%id%`
 * `GET /users/stats` - displays various statistics about the users
 * `GET /users/stats.json` - the same as above, but in JSON format

### /barcodes ###

 * `GET /barcodes` - returns all barcodes
 * `GET /barcodes.json` - the same as above, but in JSON format
 * `GET /barcodes/new` - returns the defaults for creating new barcodes
 * `GET /barcodes/new.json` - the same as above, but in JSON format
 * `POST /barcodes` - creates a new barcode; parameters are:
   * `barcode[id]` - `string` - the barcode
   * `barcode[drink]` - `int` - the ID of the drink
 * `POST /barcodes.json` - the same as above, but in JSON format
 * `DELETE /barcodes/%id%` - deletes the barcode with the id `%id%`
 * `DELETE /barcodes/%id%.json` - the same as above, but in JSON format
