# ![pokerhands](http://p0kerhands.herokuapp.com/image/logo.png "pokerhands")

- ポーカーの役を判定するRailsアプリケーションです。
- Web画面（ブラウザ）とREST APIの2つの受け口があります。
- スート（S,H,D,C）と数字（1～13）の組み合わせで構成された5枚のカード文字列を受け取ります。
- JORKER、ロイヤルストレートフラッシュには対応していません。

### Web

- ブラウザのフォームから1セットのカード情報を受け取ります。
- 対応するポーカーの役を返却して画面上に表示します。

### API

- 複数のカード情報をリクエストし、それらに対応する役と最も強い役の情報を返却します。
- 同一の役であれば同じ強さとし、スートや数字は強弱を決める際に考慮しません。

-----

## デモ

### Web

http://p0kerhands.herokuapp.com

- "S1 S2 D3 S4 S5" の形式でフォームにカード情報を入力してください。

![操作方法：Web画面](https://i.gyazo.com/b21cc57e96aa5582016d05080710bb06.gif)

### API

http://p0kerhands.herokuapp.com/api/v1/cards/check

- POST形式でリクエストします。
- ヘッダーに`CONTENT_TYPE="application/json"`を指定します。
- ボディに含まれるJSONは以下の形式でカード文字列の配列を指定してください。

#### Request

```JSON
{
  "cards": [
    "S1 S2 D3 S4 S5",
    "S1 C1 D1 H1 S5",
    "S11 S12 D7 S7 H7"
  ]
}
```

#### Response

##### 判定結果

```JSON
{
  "results": [
    {
      "card": "S1 S2 D3 S4 S5",
      "hand": "ストレート",
      "best": false
    },
    {
      "card": "S1 C1 D1 H1 S5",
      "hand": "4カード",
      "best": true
    },
    {
      "card": "S11 S12 D7 S7 H7",
      "hand": "3カード",
      "best": false
    }
  ]
}
```

##### エラーあり

```JSON
{
  "results": [
    {
      "card": "S1 S2 D3 S4 S5",
      "hand": "ストレート",
      "best": true
    }
  ],
  "errors": [
    {
      "card": "S11 S12 D7 S7 H7 H2",
      "message": "5つのカード指定文字を半角スペース区切りで入力してください。"
    }
  ]
}
```

### Architecture

- デモアプリは[Heroku]へデプロイしています。
- フリープランなのでSSL化のために[Cloudflare]を組み合わせています。

-----

## 開発環境で使うには

1. はじめにGitからコードを取得（`git clone <repository URL>`）します。
2. 必要なライブラリをbundlerを使ってインストール（`bundle install`） します。
    1. 事前に`gem install bundler`でbundlerをインストールしておいてください。
3. Railsアプリケーションを起動（`rails s`）してWeb画面/APIにアクセスできます。

-----

## Versions

- Rails 6.1.2
- Ruby 3.0.0

[Heroku]: https://jp.heroku.com/

[Cloudflare]: https://www.cloudflare.com/ja-jp/
