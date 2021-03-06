# slacken [![Build Status](https://travis-ci.org/increments/slacken.svg)](https://travis-ci.org/increments/slacken)

## Description
This gem translates a html source into a markup text for Slack.

Official description of Slack message formatting is [here](https://api.slack.com/docs/formatting).

## Examples

The following code translates [a html source](https://github.com/increments/slacken/blob/master/examples/source.html) to [a markup text](https://github.com/increments/slacken/blob/master/examples/out.txt) for Slack

```
> require 'slacken'
> puts Slacken.translate(File.read('examples/source.html'))
# *Slacken*
#
# This gem translates a html source into *a markup text for Slack*.
# <https://teams.qiita.com|Qiita:Team> uses this gem to decorate notification messages to Slack :trollface:.
#
# *Examples*
#
# *List*
#
# 1. Item 1
# 2. _Item 2 (italic)_
#     • [x] Checked
#     • [ ] Unchecked
# 3. *Item 3 (bold)*
#     • Nested Item 1
#     • Nested Item 2
#
# *Citation*
#
# > Qiita is a technical information sharing site for programmers.
# > Kobito is an application for technical information recording.
#
# *Source Code*
#
# ```class World
#   def hello
#     puts 'Hello, world!'
#   end
# end
# ```
#
# -----------
#
# *Image*
#
# This is a Qiita logo.
#
# <http://cdn.qiita.com/assets/siteid-reverse-1949e989f9d8b2f6fad65a57292b2b01.png|Qiita logo>
```

## Install

```
$ gem install slacken
```

## License
MIT
