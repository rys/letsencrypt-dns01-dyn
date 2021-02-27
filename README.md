Dyn API hook for Dehydrated
===========================

`host.rb` is a hook, driven by `hook.sh`, for [Dehydrated](https://dehydrated.de/) to get certificates from [Let's Encrypt](https://letsencrypt.org/) using the `dns-01` challenge-response method, for [Dyn](https://dyn.com/) Managed DNS.

It uses the official `dyn-rb` gem to access the Dyn REST API, configured using Dehydrated's config file.

The `dns-01` challenge-response is useful because it lets you get all of your certs from one ACME client, to save you littering clients on every host in your infrastructure that needs a cert. That's especially useful for hosts where you can't install and operate a client, like routers, where certificates can still be installed.

It's a much more sensible method than the HTTP challenge-response method for that reason.

Basic Usage
-----------

0. Clone Dehydrated
0. Clone this hook
0. Configure Dehydrated (`config` file) to tell it where the hook is, provide your Dyn account details, and provide a path to `hook.rb` for `hook.sh` to call
0. Setup your ``domains.txt``
0. Run Dehydrated and get certificates

Example Dehydrated Configuration
--------------------------------

Here's an example `config` for Dehydrated. Set it up to your own liking.

```
CA="https://acme-staging.api.letsencrypt.org/directory"
HOOK=/path/to/hook.sh
CHALLENGETYPE="dns-01"
CERTDIR="${BASEDIR}/certs"
ACCOUNTDIR="${BASEDIR}/accounts"
CONTACT_EMAIL="your.email@address.com"
# config for hook.sh and host.rb
export DYN_ACCOUNTNAME="yourdynaccountname"
export DYN_USERNAME="yourdynapiusername"
export DYN_PASSWORD="yourdynapipassword"
export HOST_RB=/path/to/host.rb
```

Notes
-----

* In the `config` above, I'm using the staging Let's Encrypt directory. Please test against that yourself before making live requests.
* It doesn't handle Dehydrated's calls to `unchanged_cert` or `deploy_cert` in `hook.sh`. You might want to fill those in to do something useful on your setup, after Dehydrated gets your certs.
* If it wasn't obvious, `host.rb` is Ruby code, so you'll need a functioning Ruby and the `dyn-rb` gem for the hook to execute properly.
* The 5 second sleeps in `host.rb` might not be necessary, they just helped me debug the order of interaction between Dehydrated and how it calls a configured hook.
