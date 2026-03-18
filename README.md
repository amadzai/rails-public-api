# Rails Public API

Rails Public API is a personal learning project for practicing Ruby on Rails as a backend framework (API only).
The focus is building a JSON REST API and getting comfortable with common Rails API patterns (routing, controllers, serialization, and error handling), plus a real ingestion flow: fetch crypto market data from CoinGecko, normalize it, store it in PostgreSQL, and serve it through public API endpoints.

## Stack

- [Ruby on Rails 8 (API-only)](https://rubyonrails.org/)
- [PostgreSQL](https://www.postgresql.org/)
- [Whenever](https://github.com/javan/whenever)
- [Rswag / OpenAPI (Swagger UI)](https://github.com/rswag/rswag)
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

   Update `.env` with your CoinGecko credentials:

3. Start PostgreSQL (Docker).

   ```bash
   docker compose up -d
   ```

4. Prepare the database:

   ```bash
   bundle exec rails db:prepare
   ```

5. Run ingestion once to seed tokens:

   ```bash
   bundle exec rails runner "FetchCryptoDataJob.perform_now"
   ```

6. Run the API server:

   ```bash
   bundle exec rails server
   ```

7. Configure local hourly ingestion with `whenever`:

   ```bash
   bundle exec whenever --update-crontab rails-public-api --set environment=development
   crontab -l
   ```

8. Open API docs to view endpoints:

   ```
   http://localhost:3000/api-docs
   ```
