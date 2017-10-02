# Rewrite rules providing support for legacy clients #

For a long time, the API wasn't properly specified.
Yet, people went ahead and built clients which are probably still in use today.

If you want to support them with a recent version of Mete,
you can apply those rewrite rules to a web server of your choice.
You may need to adjust them to your setup.

Be advised that really old clients (eg. Meteroid before v1.9)
might break in future Mete versions (because they use `/user/{id}/deposit`).

## General rules ##

```
/audits.json -> /api/v1/audits.json
/barcodes.json -> /api/v1/barcodes.json
/barcodes/new.json -> /api/v1/barcodes/new.json
/barcodes/{id}.json -> /api/v1/barcodes/{id}.json
/drinks.json -> /api/v1/drinks.json
/drinks/new.json -> /api/v1/drinks/new.json
/drinks/{id}.json -> /api/v1/drinks/{id}.json
/users.json -> /api/v1/user.json
/users/new.json -> /api/v1/users/new.json
/users/{id}.json -> /api/v1/users/{id}.json
/users/{id}/deposit.json -> /api/v1/users/{id}/deposit.json
/users/{id}/payment.json -> /api/v1/users/{id}/payment.json
/users/{id}/buy.json -> /api/v1/users/{id}/buy.json
/users/{id}/buy_barcode.json -> /api/v1/users/{id}/buy_barcode.json
/users/stats.json -> /api/v1/users/stats.json
```

## Apache httpd ##

```
RewriteEngine on
RewriteRule ^/audits\.json$ /api/v1/audits.json
RewriteRule ^/barcodes\.json$ /api/v1/barcodes.json
RewriteRule ^/barcodes/(.*)\.json$ /api/v1/barcodes/$1.json
RewriteRule ^/drinks\.json$ /api/v1/drinks.json
RewriteRule ^/drinks/(.*)\.json$ /api/v1/drinks/$1.json
RewriteRule ^/users\.json$ /api/v1/users.json
RewriteRule ^/users/(.*)\.json$ /api/v1/users/$1.json
RewriteRule "^/(.*)" "http://<mete>/$1" [P]
ProxyPassReverse "/" "http://<mete>/"
```

## nginx ##

```
rewrite ^/audits\.json$ /api/v1/audits.json last;
rewrite ^/barcodes\.json$ /api/v1/barcodes.json last;
rewrite ^/barcodes/(.*)\.json$ /api/v1/barcodes/$1.json last;
rewrite ^/drinks\.json$ /api/v1/drinks.json last;
rewrite ^/drinks/(.*)\.json$ /api/v1/drinks/$1.json last;
rewrite ^/users\.json$ /api/v1/users.json last;
rewrite ^/users/(.*)\.json$ /api/v1/users/$1.json last;
proxy_pass http://<mete>/;
```

## lighttpd ##

```
url.rewrite-once = ( 
  "^/audits\.json$" => "/api/v1/audits.json",
  "^/barcodes\.json$" => "/api/v1/barcodes.json",
  "^/barcodes/(.*)\.json$" => "/api/v1/barcodes/$1.json",
  "^/drinks\.json$" => "/api/v1/drinks.json",
  "^/drinks/(.*)\.json$" => "/api/v1/drinks/$1.json",
  "^/users\.json$" => "/api/v1/users.json",
  "^/users/(.*)\.json$" => "/api/v1/users/$1.json"
)
proxy.server = ( "" => ( ( "host" => "<mete host>", "port" => "<mete port>" ) ) )
```

