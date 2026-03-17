class FetchCryptoDataJob < ApplicationJob
  def perform(limit: Coingecko::TokenIngestor::DEFAULT_LIMIT)
    Coingecko::TokenIngestor.call(limit:)
  end
end
