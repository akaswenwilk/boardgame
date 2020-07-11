class ErrorHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      result = @app.call(env)
    rescue => e
      Hanami::Logger.new(stream: 'logfile.log').error(e.inspect)
      Hanami::Logger.new(stream: 'logfile.log').error("backtrace")
      e.backtrace.each { |trace| Hanami::Logger.new(stream: 'logfile.log').error(trace.inspect) }
      

      response_body = {
        "error_type" => e.class.name,
        "error_message" => e.message,
        "request_params" => env["router.parsed_body"],
        "backtrace" => e.backtrace
      }.to_json

      headers = {}
      headers['Access-Control-Allow-Origin'] = ENV['CORS_URL']
      headers["Access-Control-Allow-Methods"] = "*"
      headers["Access-Control-Request-Method"] = '*'
      headers["Access-Control-Allow-Headers"] = "*"

      begin
        return [e.code, headers, StringIO.new(response_body)]
      rescue
        return [500, headers, StringIO.new(response_body)]
      end
    end
  end
end
