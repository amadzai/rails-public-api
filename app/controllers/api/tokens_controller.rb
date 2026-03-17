module Api
  class TokensController < ApplicationController
    DEFAULT_LIMIT = 10
    MAX_LIMIT = 100

    def index
      tokens = Token.order(market_cap: :desc).limit(parsed_limit)
      render json: { data: tokens.map { |token| serialize_token(token) } }
    end

    def show
      token = Token.find_by!(coingecko_id: params[:id])
      render json: { data: serialize_token(token) }
    end

    def by_symbol
      symbol = params[:symbol].to_s.strip.downcase
      token = Token.where("LOWER(symbol) = ?", symbol).order(market_cap: :desc).first
      raise ActiveRecord::RecordNotFound if token.nil?

      render json: { data: serialize_token(token) }
    end

    private

    def parsed_limit
      requested = Integer(params.fetch(:limit, DEFAULT_LIMIT))
      requested.clamp(1, MAX_LIMIT)
    rescue ArgumentError, TypeError
      DEFAULT_LIMIT
    end

    def serialize_token(token)
      {
        coingecko_id: token.coingecko_id,
        symbol: token.symbol,
        name: token.name,
        image: token.image,
        current_price: token.current_price,
        market_cap: token.market_cap,
        market_cap_rank: token.market_cap_rank,
        total_volume: token.total_volume,
        price_change_percentage_24h: token.price_change_percentage_24h,
        last_ingested_at: token.last_ingested_at
      }
    end
  end
end
