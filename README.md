# badges2svg

[![Build Status](https://img.shields.io/travis/bfontaine/badges2svg.svg)](https://travis-ci.org/bfontaine/badges2svg)
[![Gem Version](https://img.shields.io/gem/v/badges2svg.svg)](http://badge.fury.io/rb/badges2svg)
[![Coverage Status](https://img.shields.io/coveralls/bfontaine/badges2svg.svg)](https://coveralls.io/r/bfontaine/badges2svg)
[![Dependency Status](https://img.shields.io/gemnasium/bfontaine/badges2svg.svg)](https://gemnasium.com/bfontaine/badges2svg)

**badges2svg** is a command-line tool to replace your GitHub README badges with
resolution-independent SVG versions from [shields.io][].

[shields.io]: http://shields.io/

## Install

```
gem install badges2svg
```

## Usage

From the command-line:

```
$ badges2svg <file>
```

<!--
## Example

```
$ badges2svg README.md
```

TODO show 'cat README' before and after -->

## Support

| Type                | Support   |
|---------------------|:---------:|
| Travis build        | ✔         |
| Gittip              | ✔         |
| Coveralls           | ✔         |
| Gemnasium           | ✔         |
| Code Climate        | ✔         |
| Gem version         | ✔         |
| PyPI version        | ✔         |
| Packagist version   | ✔         |
| PyPI downloads      | ✔         |
| Packagist downloads | ✔         |

Additionally, all badges that already use shields.io are supported.

## Tests

```
$ git clone https://github.com/bfontaine/badges2svg.git
$ cd badges2svg
$ bundle install
$ bundle exec rake test
```

