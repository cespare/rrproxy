# General form: An array of
# [pattern, target_host, <optional replacement string>]

[
  ["/foo/bar?special=true", "localhost:1234"], # Route this specific request to a local server
  [%r{^(/foo).*}, "google.com", ""],           # You can use a regex, and also replace the match with a third arg
  ["", "amazon.com"]                           # Empty string matches everything
]
