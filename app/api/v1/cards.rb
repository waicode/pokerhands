module V1


  class HandEntity < Grape::Entity
    # {card: "H1 H13 H12 H11 H10", hand: "ストレートフラッシュ", best: true}
    expose :card, documentation: {type: String, desc: "カード"}
    expose :hand, documentation: {type: String, desc: "役の名前"}
    expose :best, documentation: {desc: "最も強い役（かどうか）"}
  end

  class ErrorEntity < Grape::Entity
    # {card: "H1 H13 H12 H11 H99", msg: "エラーメッセージ" }
    expose :card, documentation: {type: String, desc: "カード"}
    expose :msg, documentation: {type: String, desc: "エラーメッセージ"}
  end

  class Cards < Grape::API

    include CardsCheck

    resource 'cards', desc: 'ユーザー' do
      # POST /v1/cards/check
      params do
        requires :cards, type: Array, desc: 'カード（配列）'
      end
      post 'check' do

        cards = params[:cards]

        @hands = []
        @errors = []

        cards.each{|card|

          c_chk = CardsCheck.new(card)

          # -------------------------------------------
          # カード文字列の形式チェック
          # -------------------------------------------

          schk_rslt =  c_chk.style_valid?

          msgs = []
          unless schk_rslt[:result]

            if schk_rslt[:targets].present?
              schk_rslt[:targets].each{ |target|
                @errors.push(
                  {card: card, msg: "#{target[:number]}番目のカード指定文字が不正です。（#{target[:char]}）"}
                )
              }
            else
              @errors.push(
                {card: card, msg: '5つのカード指定文字は半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）'}
              )
            end

          end

          # -------------------------------------------
          # 重複チェック
          # -------------------------------------------

          unless c_chk.uniq?
            @errors.push(
              {card: card, msg: "カードが重複しています。"}
            )
          end


          # -------------------------------------------
          # 役の判定
          # -------------------------------------------

          c_chk.gen_list
          hand = c_chk.check_hands

          # TODO: ここから！

        }

        @hands = [
          {card: "S10 S11 S12 S13 S1", hand: "Straight flush", best: true},
          {card: "S10 H10 D10 C10 S1", hand: "Four of a kind", best: false},
          {card: "S1 S11 H12 D4 C7", hand: "High Card", best: false}
        ]

        @errors = [
          {card: "A B C D E", msg: "Error01"},
          {card: "S1 S2 S3 S4 S99", msg: "Error02"}
        ]

        present :result, @hands, with: HandEntity
        present :error, @errors, with: ErrorEntity
      end
    end

  end

end