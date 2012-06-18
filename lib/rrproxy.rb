require "goliath/api"
require "goliath/goliath"
require "goliath/rack"
require "goliath/server"
require "log4r"
require "em-synchrony/em-http"

class RRProxy < Goliath::API
  class << self
    attr_accessor :routes
  end

  use Goliath::Rack::Params

  def options_parser(option_parser, options)
    option_parser.on("-c", "--config CONFIG_FILE", "Ruby routes configuration file") do |filename|
      options[:config] = filename
    end
    abort "asdf" unless File.file?(options[:config])
  end

  def on_headers(env, headers) env["untampered_headers"] = headers end

  def response(env)
    uri = env["REQUEST_URI"]
    method = env["REQUEST_METHOD"]
    logger.info "Proxying #{method} #{uri}"
    method = method.downcase.to_sym
    RRProxy.routes.each do |pattern, target, replacement|
      if pattern.is_a?(Regexp)
        next unless uri =~ pattern
        uri.sub!($1, replacement) if replacement
      else
        next unless uri.start_with? pattern
        uri.sub!(pattern, replacement) if replacement
      end

      target_url = "http://#{target}#{uri}"
      headers = env["untampered_headers"]

      # Try to make it look as much as possible like the request originates with us. This removes a bunch of
      # security protections and is a reason rrproxy is only for development/testing puproses.
      headers["Host"] = target
      headers.delete "Referer"

      params = { :head => headers }
      params[:body] = env["params"] if [:put, :post, :patch].include? method

      http = EM::HttpRequest.new(target_url).send(method, params)
      response_headers = {}
      http.response_header.each do |k, v|
        response_headers[k.downcase.split("_").map(&:capitalize).join("-")] = v
      end

      return [http.response_header.status, response_headers, [http.response]]
    end
    [503, {}, "No target specified for this path."]
  end
end
