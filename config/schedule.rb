set :environment, ENV.fetch("RAILS_ENV", "development")
set :output, "log/cron.log"
set :bundle_command, "#{ENV['HOME']}/.rbenv/shims/bundle exec"

every 1.hour do
  runner "FetchCryptoDataJob.perform_now"
end
