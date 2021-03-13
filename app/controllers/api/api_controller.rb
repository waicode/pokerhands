class Api::ApiController < ActionController::Base

  include Const

  skip_before_action :verify_authenticity_token

  rescue_from Exception, with: :fatal_error

  def fatal_error()
    # その他の例外
    render json: { errors: [{ msg: MSG_ERR_SYS_ERR }] }, status: :internal_server_error
  end

  def not_found_error()
    # ルーティングなし
    render json: { errors: [{ msg: MSG_ERR_INV_URL }] }, status: :not_found
  end

end