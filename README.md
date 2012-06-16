rrproxy
=======

rrproxy ("routing reverse proxy" or "rockin' ruby proxy" -- you pick) is a very simple reverse proxy server
that can route requests to different servers based on simple pattern-matching rules against the requests. It
is intended for use in a development environment as a substitute for 'real' proxies (nginx/HAProxy/whatever)
that you use in production.

Installation
------------

    $ gem install rrproxy

rrproxy requires Ruby 1.9 (because it's based on Goliath).

Usage
-----

rrproxy takes a very simple Ruby configuration file.

    [
      ["/styles/screen.css", "localhost:8000"],
      ["", "example.com"]
    ]

As you can probably guess, this will redirect requests for example.com's css file to a local server (while
passing all other requests through normally).

Here's a more complicated example (it's also in `examples/example_config.rb`):

    [
      ["/foo/bar?special=true", "localhost:1234"], # Route this specific request to a local server
      [%r{^(/foo).*}, "google.com", ""],           # You can use a regex, and also replace the match with a third arg
      ["", "amazon.com"]                           # Empty string matches everything
    ]

You will provide an array of tuples, where each one is of the form

    [pattern, target_host, <optional replacement string>]

For each request, rrproxy will examine each routing rule in order, checking for a prefix match (if the pattern
is a string) or a regex match. The first match found will be used, and the host for the request will be
changed to the corresponding target host. If a replacement is provided, it will be used as a substitute for
the first regex matching group (if the pattern is a regex) or the whole pattern (if the pattern is a string).

Credits
-------

* @tobert for the idea to use Goliath
* The PostRank folks for a kickass server framework
