class ErrorHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue => e
      response_body = {
        "error_type" => e.class.name,
        "error_message" => e.message,
        "request_params" => env["router.parsed_body"],
        "backtrace" => e.backtrace
      }.to_json

      begin
        return [e.code, {}, response_body]
      rescue
        return [500, {}, response_body]
      end
    end
  end
end
