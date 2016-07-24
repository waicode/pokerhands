module V1
  class Root < Grape::API

    version 'v1'
    format :json

    rescue_from :all do |e|
      error!({ error: [{ msg: "システムエラーが発生しました。"}] }, 500)
    end

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      error!({ error: [{ msg: "不正なリクエストです。"}] }, 400)
    end

    # Each APIs
    mount V1::Cards

    route :any, '*path' do
      error!({ error: [{ msg: "不正なURLです。"}] }, 404)
    end

  end
end