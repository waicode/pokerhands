module Middleware
  class RescueJsonParseErrors
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue ActionDispatch::Http::Parameters::ParseError
      unless %r{application/json}.match?(env['HTTP_ACCEPT'])
        Api::ApiErrorsController.action(:dispatch_error).call(env)
      end
      Api::ApiErrorsController.action(:parse_error).call(env)
    rescue => e
      Api::ApiErrorsController.action(:dispatch_error).call(env)
    end
  end
end