class Api::ApiErrorsController < ActionController::Base

  include Const

  skip_before_action :verify_authenticity_token

  def parse_error()
    # JSONのパースエラー
    render json: { errors: [{ msg: MSG_ERR_INV_REQ }] }, status: :bad_request
  end

  def dispatch_error()
    # その他のミドルウェア例外
    render json: { errors: [{ msg: MSG_ERR_SYS_ERR }] }, status: :internal_server_error
  end

  def not_found_error()
    # ルーティングなし
    render json: { errors: [{ msg: MSG_ERR_INV_URL }] }, status: :not_found
  end

end