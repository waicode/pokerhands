class Api::V1::CardsController < Api::ApiController

  include Const

  def check
    cards = params[:cards]

    @hands = []
    @errors = []

    _cards_tmp = []
    _hands_tmp = []
    _bests_tmp = []

    if cards.blank? or !cards.instance_of?(Array)
      # cardsのパラメータがない、または配列でない場合はリクエストエラー
      render json: { errors: [{ msg: MSG_ERR_INV_PRM }] }, status: :bad_request and return
    end

    cards.each { |card|

      c_chk = CardsCheck.new(card)

      # -------------------------------------------
      # カード文字列の形式チェック
      # -------------------------------------------

      schk_rslt = c_chk.style_valid?

      unless schk_rslt[:result]

        if schk_rslt[:targets].present?
          schk_rslt[:targets].each { |target|
            @errors.push(
              { card: card, msg: "#{target[:number]}#{MSG_ERR_NTH_CD_STYL} (#{target[:char]})" }
            )
          }
        else
          @errors.push(
            { card: card, msg: MSG_ERR_SPRT_SPC }
          )
        end
        next
      end

      # -------------------------------------------
      # 重複チェック
      # -------------------------------------------

      unless c_chk.uniq?
        @errors.push(
          { card: card, msg: MSG_ERR_CD_DUP }
        )
        next
      end

      # -------------------------------------------
      # 役の判定
      # -------------------------------------------

      c_chk.gen_list
      hand_key = c_chk.check_hands

      _cards_tmp.push(card)
      _hands_tmp.push(hand_key)

    }

    if _hands_tmp.present?
      h_chk = HandsCheck.new(_hands_tmp)
      _bests_tmp = h_chk.best_list
      _hands_tmp.each_with_index { |_, i|
        @hands.push({ card: _cards_tmp[i], hand: HANDS_NAME[_hands_tmp[i]], best: _bests_tmp[i] })
      }
    end

    # 判定結果あり（200）
    if @hands.present?
      if @errors.blank?
        render json: { results: @hands }, status: :ok and return
      else
        render json: { results: @hands, errors: @errors }, status: :ok and return
      end
    end

    # エラー結果のみ（400）
    if @errors.present?
      render json: { errors: @errors }, status: :bad_request and return
    end

    # 判定結果もエラー結果もない場合はシステムエラー
    render json: { error: [{ msg: MSG_ERR_SYS_ERR }] }, status: :internal_server_error and return

  end

end
