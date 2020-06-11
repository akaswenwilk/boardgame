class CrossOriginHeaders
  def initialize(app)
    @app = app
  end

  def call(env)
    unless env["REQUEST_METHOD"] == "OPTIONS"
      result = @app.call(env)

      if result.length == 2
        headers = {}
      else
        headers = result[1]
      end

      Hanami::Logger.new(stream: 'logfile.log').info("the env #{env["REQUEST_METHOD"]}")
      headers['Access-Control-Allow-Origin'] = 'http://localhost:3001'
      headers["Access-Control-Allow-Methods"] = "*"
      headers["Access-Control-Request-Method"] = '*'
      headers["Access-Control-Allow-Headers"] = "*"

      return result
    else
      headers = {}
      headers['Access-Control-Allow-Origin'] = 'http://localhost:3001'
      headers["Access-Control-Allow-Methods"] = "*"
      headers["Access-Control-Request-Method"] = '*'
      headers["Access-Control-Allow-Headers"] = "*"

      return [200, headers, StringIO.new("GET, DELETE, POST, OPTIONS")]
    end
  end
end
