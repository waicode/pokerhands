class TopController < ApplicationController

  include Const

  def show; end

  def check

    # -------------------------------------------
    # 事前処理
    # -------------------------------------------

    session[:cards] = params[:cards]
    c_chk = CardsCheck.new(params[:cards])

    # -------------------------------------------
    # カード文字列の形式チェック
    # -------------------------------------------

    schk_rslt =  c_chk.style_valid?

    msgs = []
    unless schk_rslt[:result]
      if schk_rslt[:targets].present?
        schk_rslt[:targets].each{ |target|
          msgs.push("#{target[:number]}番目のカード指定文字が不正です。（#{target[:char]}）")
        }
        msgs.push("半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。")
      else
        msgs.push('5つのカード指定文字は半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）')
      end
      session[:hand_name] = nil
      redirect_to root_path, alert: msgs.join("\n") and return
    end

    # -------------------------------------------
    # 重複チェック
    # -------------------------------------------

    unless c_chk.uniq?
      msgs.push("カードが重複しています。")
      session[:hand_name] = nil
      redirect_to root_path, alert: msgs.join("\n") and return
    end

    # -------------------------------------------
    # 役の判定
    # -------------------------------------------

    c_chk.gen_list
    session[:hand_name] = HANDS_NAME[c_chk.check_hands]
    redirect_to root_path

  end

end
