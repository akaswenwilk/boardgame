require 'sequel'

database_url = URI::Generic.build(
  scheme: "postgres",
  userinfo: "#{ENV['DB_USER']}:#{ENV['DB_PASSWORD']}",
  host: ENV["DB_HOST"],
  port: 5432,
  path: "/#{ENV['DB_NAME']}"
).to_s


DB = Sequel.connect(database_url)
