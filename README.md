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

### As a developer

[How the API works.](https://github.com/chaosdorf/mete/blob/master/API.md)

### As an admin

[How to setup the server.](https://github.com/chaosdorf/mete/blob/master/Setup.md)
