[![build status](https://travis-ci.org/chaosdorf/mete.svg?branch=master)](https://travis-ci.org/chaosdorf/mete)
[![documentation status](https://inch-ci.org/github/chaosdorf/mete.svg?branch=master)](https://inch-ci.org/github/chaosdorf/mete)
[![Code Climate](https://codeclimate.com/github/chaosdorf/mete/badges/gpa.svg)](https://codeclimate.com/github/chaosdorf/mete)
[![test coverage](https://codeclimate.com/github/chaosdorf/mete/badges/coverage.svg)](https://codeclimate.com/github/chaosdorf/mete/coverage)

# Matekasse

Keep track of your donations!

This web application is for places where people can donate to get a drink. Just
create an account, donate some money and count down while drinking Mate (or some
other beverage).

This code is intended to be simple, full of security problems and lacking a lot
of features. Please hack on it.


## Getting started

### As a user

1. Access your mete instance

mete doesn't have any kind of discoverability built in. If you know the URL of an instance, you can access it by simply pointing your browser there. Or use one of the apps:
 * Android App: (https://github.com/chaosdorf/meteroid)
 * iOS App: (https://github.com/chaosdorf/meteroid-ios)
 * Sailfish OS App: (https://github.com/r4mp/harbour-meteroid)

2. Select your account

The first screen you'll see presents a list of users.
If you already have an account at this instance, go ahead and select it by tapping.

If you don't, you can simply create one by pressing the 'new user' button.
This opens a screen where you can fill in a username, your email and an initial account balance.
(You don't need to put your email there, it's just being used for [Gravatar](https://gravatar.com/).)
After entering your details and confirming, you'll be presented your user page.


3. Your user page

Here, you can donate for stuff by simply tapping the product. Or you can modify or delete your account.

### As a developer of an app

Mete currently implements [version 1](https://space-market.github.io/API/preview/v1/) of the [Space-Market API](https://github.com/Space-Market/API). The endpoint is located at `/api/v1`.

Out-of-date instances of mete provide an API at `/` that is somewhat similar.
Current installations may provide legacy support at `/` but please don't depend on this if you're developing a client.

Please also don't parse the HTML returned by mete or anything not in `/api`.

### As a developer of mete

Thanks for wanting to contribute. :)

This is a relatively standard Rails application (which means that most code resides in the `app` folder).

If you're new to the codebase you might want to take a look at the [issues labeled 'good first issue'](https://github.com/chaosdorf/mete/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22).

Also, there are tests for most parts of the application in `test` if you want to take a look.

### As an admin

[How to setup the server.](https://github.com/chaosdorf/mete/blob/master/Setup.md)
