# Setup #

## Setup ##

```
sudo apt install ruby ruby-dev bundler git zlib1g-dev libsqlite3-dev sqlite3 imagemagick nodejs
git clone https://github.com/chaosdorf/mete.git
cd mete
bundle
rake db:migrate
cd var
cp default_config.yaml config.yaml # you'll want to adjust this
ln -s currency-images-default currency-images # or cp
cd ..
```

## Run ##

```
cd mete
rails server -b 0.0.0.0
```

**TODO**: *Production server?*

## Update ##

Stop the server.

```
cd mete
cp db/production.sqlite3 db/production.sqlite3.bak
git pull
rake db:migrate
```

Start the server.
