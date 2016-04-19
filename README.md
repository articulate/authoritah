# authoritah

Authoritah is a tool for managing [Auth0](https://auth0.com/) rules via declarative configuration.

[![Build Status](https://travis-ci.org/articulate/authoritah.svg?branch=master)](https://travis-ci.org/articulate/authoritah)

![authoritah](http://data.boomerang.nl/b/boomerang/image/respect-my-authority/s600/southparkvz.jpg)

## Installation

Download the [latest](https://github.com/articulate/authoritah/releases/latest) version for your platform (Linux, OSX).

Place binary somewhere on your path and set execution permissions (`chmod +x authoritah`).

Alternatively, we provide a [Docker container](https://hub.docker.com/r/articulate/authoritah/) for this executable which you can use.

The image will attempt to mount whatever volume you supply (`-v`) pointing to `/auth0` as the point from which it will load the `rules.yml` config and rule script definitions. This will typically be the same directory you are running `authoritah` from.

```bash
docker pull articulate/authoritah
docker run --rm -ti -v $(pwd):/auth0 articulate/authoritah help
```

## The `help`

```
  authoritah - Authoritah is a tool for managing Auth0 configuration via declarative configuration.

  Usage:
    authoritah [command] [arguments]

  Commands:
    apply [rules file]      # Applies config to an Auth0 instance
    config [cmd] [options]  # Set biplane configuration options
    diff [rules file]       # Shows differences between existing ruleset and local config
    dump [rules file]       # Saves server ruleset to local file
    help [command]          # Help about any command.
    jwt [refresh]           # Generate a JWT or force a refresh of the token

  Flags:
    -h, --help  # Help for this command. default: 'false'.
```

## Contributing

1. Fork it ( https://github.com/plukevdh/authoritah/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [plukevdh](https://github.com/plukevdh) Luke van der Hoeven - creator, maintainer
