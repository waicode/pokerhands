module Middleware
  class RescueJsonParseErrors

    include Const

    CONTENT_TYPE_JSON_HASH = { 'Content-Type' => 'application/json' }

    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue ActionDispatch::Http::Parameters::ParseError
      # JSONパースエラー
      [400, CONTENT_TYPE_JSON_HASH, [{ errors: [{ message: MSG_ERR_INV_JSN }] }.to_json]]
    rescue => e
      [500, CONTENT_TYPE_JSON_HASH, [{ errors: [{ message: MSG_ERR_SYS_ERR }] }.to_json]]
    end
  end
end