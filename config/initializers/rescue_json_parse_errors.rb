module Middleware
  class RescueJsonParseErrors
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue ActionDispatch::Http::Parameters::ParseError
      unless %r{application/json}.match?(env['HTTP_ACCEPT'])
        ApiErrorsController.action(:dispatch_error).call(env)
      end
      ApiErrorsController.action(:parse_error).call(env)
    rescue => e
      ApiErrorsController.action(:dispatch_error).call(env)
    end
  end
end