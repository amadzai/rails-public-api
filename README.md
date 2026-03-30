# Rails Public API

Rails Public API is a personal learning project for practicing Ruby on Rails as a backend framework (API only).

The focus is building a JSON REST API with common Rails API patterns (routing, controllers, serialization), and an hourly ingestion flow that fetches crypto market data from CoinGecko.

The data is then normalized, stored in a PostgreSQL DB, and served through public (local) API endpoints.

## Stack

- [Ruby on Rails 8 (API-only)](https://rubyonrails.org/)
- [PostgreSQL](https://www.postgresql.org/)
- [Whenever](https://github.com/javan/whenever)
- [Rswag](https://github.com/rswag/rswag)
- [CoinGecko API](https://www.coingecko.com/en/api)

## Local Setup

1. Clone and install dependencies:

   ```bash
   git clone git@github.com:amadzai/rails-public-api.git
   cd rails-public-api
   bundle install
   ```

2. Configure environment variables:

   ```bash
   cp .env.example .env
   ```

   Update `.env` with your CoinGecko credentials

3. Start Services (Web / Puma Server & PostgreSQL DB):

   ```bash
   docker compose up -d
   ```

4. Run ingestion once to seed tokens:

   ```bash
   docker compose exec web bin/rails runner "FetchCryptoDataJob.perform_now"
   ```

5. Configure local hourly ingestion with `whenever`:

   ```bash
   bundle exec whenever --update-crontab rails-public-api --set environment=development
   crontab -l
   ```

6. Open API docs to view endpoints:

   ```
   http://localhost:3001/api-docs
   ```
