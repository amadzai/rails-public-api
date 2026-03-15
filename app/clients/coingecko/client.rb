require "net/http"
require "json"

module Coingecko
  class Client
    class Error < StandardError; end

    DEFAULT_TIMEOUT_SECONDS = 10
    DEFAULT_VS_CURRENCY = "usd"
    DEFAULT_ORDER = "market_cap_desc"
    DEFAULT_PRICE_CHANGE_PERCENTAGE = "24h"
    MARKETS_PATH = "/coins/markets"

    def initialize(
      base_url: ENV.fetch("COINGECKO_BASE_URL", "https://api.coingecko.com/api/v3"),
      api_key: ENV["COINGECKO_API_KEY"],
      api_key_header: ENV.fetch("COINGECKO_API_KEY_HEADER", "x-cg-demo-api-key"),
      timeout: DEFAULT_TIMEOUT_SECONDS
    )
      @base_url = base_url
      @api_key = api_key
      @api_key_header = api_key_header
      @timeout = timeout
    end

    def markets(vs_currency: DEFAULT_VS_CURRENCY, per_page: 10, page: 1)
      uri = URI("#{@base_url}#{MARKETS_PATH}")
      uri.query = URI.encode_www_form(markets_query(vs_currency:, per_page:, page:))

      request = build_request(uri)

      response = Net::HTTP.start(
        uri.hostname,
        uri.port,
        use_ssl: uri.scheme == "https",
        open_timeout: @timeout,
        read_timeout: @timeout
      ) { |http| http.request(request) }

      unless response.is_a?(Net::HTTPSuccess)
        raise Error, "CoinGecko request failed: #{response.code} #{response.body}"
      end

      body = JSON.parse(response.body)
      raise Error, "Expected array response, got #{body.class}" unless body.is_a?(Array)

      body
    rescue JSON::ParserError => e
      raise Error, "CoinGecko JSON parse failed: #{e.message}"
    rescue Net::OpenTimeout, Net::ReadTimeout => e
      raise Error, "CoinGecko timeout: #{e.class}"
    rescue SocketError => e
      raise Error, "CoinGecko network error: #{e.message}"
    end

    private

    def markets_query(vs_currency:, per_page:, page:)
      {
        vs_currency:,
        order: DEFAULT_ORDER,
        per_page:,
        page:,
        sparkline: false,
        price_change_percentage: DEFAULT_PRICE_CHANGE_PERCENTAGE
      }
    end

    def build_request(uri)
      request = Net::HTTP::Get.new(uri)
      request["Accept"] = "application/json"
      request[@api_key_header] = @api_key if @api_key && !@api_key.empty?
      request
    end
  end
end
