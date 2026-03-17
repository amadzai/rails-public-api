require "bigdecimal"

module Coingecko
  class TokenNormalizer
    class Error < StandardError; end

    REQUIRED_STRING_KEYS = %w[id symbol name]
    REQUIRED_DECIMAL_KEYS = %w[current_price market_cap]

    def self.call(item, ingested_at: Time.current)
      new(item, ingested_at:).call
    end

    def initialize(item, ingested_at:)
      @item = item
      @ingested_at = ingested_at
    end

    def call
      validate_required_keys!

      {
        coingecko_id: required_string("id"),
        symbol: required_string("symbol"),
        name: required_string("name"),
        image: optional_string("image"),
        current_price: required_decimal("current_price"),
        market_cap: required_decimal("market_cap"),
        market_cap_rank: optional_integer("market_cap_rank"),
        total_volume: optional_decimal("total_volume"),
        price_change_percentage_24h: optional_decimal("price_change_percentage_24h"),
        last_ingested_at: @ingested_at
      }
    end

    private

    def validate_required_keys!
      (REQUIRED_STRING_KEYS + REQUIRED_DECIMAL_KEYS).each do |key|
        value = fetch_value(key)
        raise Error, "Missing required key: #{key}" if value.nil?
      end
    end

    def fetch_value(key)
      @item[key] || @item[key.to_sym]
    end

    def required_string(key)
      value = fetch_value(key).to_s.strip
      raise Error, "Invalid empty value for key: #{key}" if value.empty?

      value
    end

    def optional_string(key)
      value = fetch_value(key).to_s.strip
      return nil if value.empty?

      value
    end

    def required_decimal(key)
      value = fetch_value(key)

      BigDecimal(value.to_s)
    rescue ArgumentError
      raise Error, "Invalid decimal value for key: #{key}"
    end

    def optional_decimal(key)
      value = fetch_value(key)
      return nil if value.nil?

      BigDecimal(value.to_s)
    rescue ArgumentError
      raise Error, "Invalid decimal value for key: #{key}"
    end

    def optional_integer(key)
      value = fetch_value(key)
      return nil if value.nil?

      Integer(value)
    rescue ArgumentError, TypeError
      raise Error, "Invalid integer value for key: #{key}"
    end
  end
end
