require 'rails_helper'

include Const

describe Api::V1::CardsController, :type => :request do

  before do
    @path = '/api/v1/cards/check'
    @opts = { 'CONTENT_TYPE' => 'application/json', "HTTP_ACCEPT" => 'application/json' }
  end

  describe '不正なリクエスト' do

    before do
      @path_invalid = '/api/v1/abc'
      @pattern_json = { errors: [{ message: MSG_ERR_INV_JSN }] }
      @pattern_pram = { errors: [{ message: MSG_ERR_INV_PRM }] }
      @pattern_e400 = { errors: [{ message: MSG_ERR_INV_REQ }] }
      @pattern_e404 = { errors: [{ message: MSG_ERR_INV_URL }] }
      @pattern_e500 = { errors: [{ message: MSG_ERR_SYS_ERR }] }
    end

    it "ボディのJSONが壊れている→不正リクエスト" do
      post @path, params: "{", headers: @opts
      p "ボディのJSONが壊れている: #{response.body}"
      expect(response.status).to eq(400)
      expect(response.body).to match_json_expression(@pattern_json)
    end

    it "ボディが空→不正リクエスト" do
      post @path, params: "", headers: @opts
      p "ボディが空: #{response.body}"
      expect(response.status).to eq(400)
      expect(response.body).to match_json_expression(@pattern_pram)
    end

    it "ボディ{}のみ→不正リクエスト" do
      post @path, params: "{}", headers: @opts
      p "ボディ{}のみ: #{response.body}"
      expect(response.status).to eq(400)
      expect(response.body).to match_json_expression(@pattern_pram)
    end

    it "ボディにcards要素が無い→不正リクエスト" do
      post @path, params: '{"aaa": ["aaa"]}', headers: @opts
      p "ボディにcards要素が無い: #{response.body}"
      expect(response.status).to eq(400)
      expect(response.body).to match_json_expression(@pattern_pram)
    end

    it "ボディのcards要素の値がnull→不正リクエスト" do
      post @path, params: '{"cards": null}', headers: @opts
      p "ボディのcards要素の値がnull: #{response.body}"
      expect(response.status).to eq(400)
      expect(response.body).to match_json_expression(@pattern_pram)
    end

    it "ボディのcards要素の値が空文字" do
      post @path, params: '{"cards": ""}', headers: @opts
      p "ボディのcards要素の値が空文字: #{response.body}"
      expect(response.status).to eq(400)
      expect(response.body).to match_json_expression(@pattern_pram)
    end

    it "ボディのcards要素の値が空の配列" do
      post @path, params: '{"cards": []}', headers: @opts
      p "ボディのcards要素の値が空文字: #{response.body}"
      expect(response.status).to eq(400)
      expect(response.body).to match_json_expression(@pattern_pram)
    end

    it "API配下でパスが不正→不正なURL" do
      post @path_invalid, params: '{"cards": ["S1 S2 S3 S4 S5"]}', headers: @opts
      p "API配下でパスが不正: #{response.body}"
      expect(response.status).to eq(404)
      expect(response.body).to match_json_expression(@pattern_e404)
    end

  end

  describe '正常なリクエスト' do

    describe "エラーなし" do

      describe "単数" do

        it "1件→正常" do
          req = { cards: ["S1 S2 D3 S4 S5"] }
          post @path, params: req.to_json, headers: @opts
          p "単数 1件: #{response.body}"
          expect(response.status).to eq(200)
          pattern = { results: [{ card: "S1 S2 D3 S4 S5", hand: HANDS_NAME[HD_STRT], best: true }] }
          expect(response.body).to match_json_expression(pattern)
        end

      end

      describe "複数件" do

        it "1つのベスト→正常" do
          req = { cards: ["S1 S2 D3 S4 S5", "S1 S2 S3 S8 S12", "S13 D1 S8 C9 S2"] }
          post @path, params: req.to_json, headers: @opts
          p "複数件 1つのベスト: #{response.body}"
          expect(response.status).to eq(200)
          pattern = { results: [
            { card: "S1 S2 D3 S4 S5", hand: HANDS_NAME[HD_STRT], best: false },
            { card: "S1 S2 S3 S8 S12", hand: HANDS_NAME[HD_FLSH], best: true },
            { card: "S13 D1 S8 C9 S2", hand: HANDS_NAME[HD_HI_CD], best: false }
          ] }
          expect(response.body).to match_json_expression(pattern)
        end

        it "複数のベスト→正常" do
          req = { cards: ["S1 D1 H1 S4 S5", "S1 S2 S3 S8 S12", "S13 D1 S9 C9 S2", "S1 S2 S3 S8 S12"] }
          post @path, params: req.to_json, headers: @opts
          p "複数件 複数のベスト: #{response.body}"
          expect(response.status).to eq(200)
          pattern = { results: [
            { card: "S1 D1 H1 S4 S5", hand: HANDS_NAME[HD_3_KD], best: false },
            { card: "S1 S2 S3 S8 S12", hand: HANDS_NAME[HD_FLSH], best: true },
            { card: "S13 D1 S9 C9 S2", hand: HANDS_NAME[HD_1_PR], best: false },
            { card: "S1 S2 S3 S8 S12", hand: HANDS_NAME[HD_FLSH], best: true }
          ] }
          expect(response.body).to match_json_expression(pattern)
        end

        it "全てベスト→正常" do
          req = { cards: ["S1 D1 H1 S4 S5", "S2 D2 H2 S4 S5", "D8 S2 S3 S8 H8"] }
          post @path, params: req.to_json, headers: @opts
          p "複数件 全てベスト: #{response.body}"
          expect(response.status).to eq(200)
          pattern = { results: [
            { card: "S1 D1 H1 S4 S5", hand: HANDS_NAME[HD_3_KD], best: true },
            { card: "S2 D2 H2 S4 S5", hand: HANDS_NAME[HD_3_KD], best: true },
            { card: "D8 S2 S3 S8 H8", hand: HANDS_NAME[HD_3_KD], best: true }
          ] }
          expect(response.body).to match_json_expression(pattern)
        end

      end

    end

    describe "エラーあり" do

      describe "単数" do
        it "1件→カード全体の形式エラー" do
          req = { cards: ["S1S2D3 S4 S5"] }
          post @path, params: req.to_json, headers: @opts
          p "単数 1件 カード全体の形式エラー: #{response.body}"
          expect(response.status).to eq(400)
          pattern = { errors: [{ card: "S1S2D3 S4 S5", message: MSG_ERR_SPRT_SPC }] }
          expect(response.body).to match_json_expression(pattern)
        end
        it "1件→1番目のカード形式エラー" do
          req = { cards: ["S99 S2 D3 S4 S5"] }
          post @path, params: req.to_json, headers: @opts
          p "単数 1件 1番目のカード形式エラー: #{response.body}"
          expect(response.status).to eq(400)
          pattern = { errors: [{ card: "S99 S2 D3 S4 S5", message: "1#{MSG_ERR_NTH_CD_STYL} (S99)" }] }
          expect(response.body).to match_json_expression(pattern)
        end
        it "1件→2番目と5番目のカード形式エラー" do
          req = { cards: ["S9 AA D9 S4 BB"] }
          post @path, params: req.to_json, headers: @opts
          p "単数 1件 2番目と5番目のカード形式エラー: #{response.body}"
          expect(response.status).to eq(400)
          pattern = { errors: [
            { card: "S9 AA D9 S4 BB", message: "2#{MSG_ERR_NTH_CD_STYL} (AA)" },
            { card: "S9 AA D9 S4 BB", message: "5#{MSG_ERR_NTH_CD_STYL} (BB)" }
          ] }
          expect(response.body).to match_json_expression(pattern)
        end
      end

      describe "複数" do

        describe "エラーのみ" do
          it "3件→カード全体の形式エラー、1番目のカード形式エラー、2番目と5番目のカード形式エラー" do
            req = { cards: ["S1S2D3 S4 S5", "S99 S2 D3 S4 S5", "S9 AA D9 S4 BB"] }
            post @path, params: req.to_json, headers: @opts
            p "複数 エラーのみ: #{response.body}"
            expect(response.status).to eq(400)
            pattern = {
              errors: [
                { card: "S1S2D3 S4 S5", message: MSG_ERR_SPRT_SPC },
                { card: "S99 S2 D3 S4 S5", message: "1#{MSG_ERR_NTH_CD_STYL} (S99)" },
                { card: "S9 AA D9 S4 BB", message: "2#{MSG_ERR_NTH_CD_STYL} (AA)" },
                { card: "S9 AA D9 S4 BB", message: "5#{MSG_ERR_NTH_CD_STYL} (BB)" }
              ]
            }
            expect(response.body).to match_json_expression(pattern)
          end
        end

        describe "正常とエラー混合" do
          it "6件→正常3件とエラー結果4件" do
            req = { cards: ["S1 S2 S3 S4 S5", "S9 D9 H9 S1 D1", "S1 S7 S9 D4 C9", "S1S2D3 S4 S5", "S99 S2 D3 S4 S5", "S9 AA D9 S4 BB"] }
            post @path, params: req.to_json, headers: @opts
            p "複数 正常とエラー混合: #{response.body}"
            expect(response.status).to eq(200)
            pattern = {
              results: [
                { card: "S1 S2 S3 S4 S5", hand: HANDS_NAME[HD_STRT_FLSH], best: true },
                { card: "S9 D9 H9 S1 D1", hand: HANDS_NAME[HD_FL_HUS], best: false },
                { card: "S1 S7 S9 D4 C9", hand: HANDS_NAME[HD_1_PR], best: false }
              ],
              errors: [
                { card: "S1S2D3 S4 S5", message: MSG_ERR_SPRT_SPC },
                { card: "S99 S2 D3 S4 S5", message: "1#{MSG_ERR_NTH_CD_STYL} (S99)" },
                { card: "S9 AA D9 S4 BB", message: "2#{MSG_ERR_NTH_CD_STYL} (AA)" },
                { card: "S9 AA D9 S4 BB", message: "5#{MSG_ERR_NTH_CD_STYL} (BB)" }
              ]
            }
            expect(response.body).to match_json_expression(pattern)
          end
        end

      end

    end

  end

end