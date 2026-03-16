module Coingecko
  class TokenIngestor
    UPSERT_UNIQUE_INDEX = :index_tokens_on_coingecko_id
    DEFAULT_LIMIT = 10

    def self.call(limit: DEFAULT_LIMIT, client: Client.new, ingested_at: Time.current)
      new(limit:, client:, ingested_at:).call
    end

    def initialize(limit:, client:, ingested_at:)
      @limit = limit
      @client = client
      @ingested_at = ingested_at
    end

    def call
      items = @client.markets(per_page: @limit)
      attributes = items.map { |item| TokenNormalizer.call(item, ingested_at: @ingested_at) }
      return { fetched: 0, upserted: 0 } if attributes.empty?

      Token.upsert_all(
        attributes,
        unique_by: UPSERT_UNIQUE_INDEX,
        record_timestamps: true
      )

      { fetched: items.size, upserted: attributes.size }
    end
  end
end
