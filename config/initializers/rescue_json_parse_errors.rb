module Middleware
  class RescueJsonParseErrors
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue ActionDispatch::Http::Parameters::ParseError
      raise unless %r{application/json}.match?(env['HTTP_ACCEPT'])

      [
        400, { 'Content-Type' => 'application/json' },
        [{ status: 400, error: 'You submitted a malformed JSON.' }.to_json]
      ]
    end
  end
end