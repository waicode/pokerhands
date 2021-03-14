![pokerhands](https://i.gyazo.com/ed60929f49851d1ba31131dfde793264.png "pokerhands")

## 📕 Rails Practical Learning Contents

### またの名を **「Railsの試練」**

- Ruby on Rails初学者向けの **実践を意識したサンプルアプリケーション構築** の教材です。
    - このリポジトリには「一つの解答」としてサンプルコードを載せています。
    - サンプルコードを見ずにChallengeの内容を見て自力で取り組んでみてください。
- 取り組むにあたって、**一般的なRails学習教材は一通り終えていること**を前提としています。
- 写経せず、サンプルアプリケーションを自力でつくることで、以下について学べます。
    1. Railsフレームワークにおける基本構成
    1. ビジネスロジックの書き方
    1. Web画面/APIで共通で使うロジックの汎化
- なお、OR Mapper（Active Record）を使ったModelとDatabaseの接続はありません。
    - Database接続が必要なアプリの構築は別の教材で学んでください。

### どこが実践的？

- RailsでWeb画面/APIをつくる際の基本を抑えることができます。
- ビジネスロジックを汎化させるDRY原則な書き方が身につきます。
- DB接続なしは賛否両論ですが、MVCを自ら崩して使えるかどうかが試されます。

## 🔥 Challenge

### Overview

- ポーカーの役判定をするアプリケーションを作成してください。
    - 入力された文字列を「カードの数字とスートの組み合わせ」とみなします。
        - 1文字で表されるスート（S,H,D,C）と1から13の数字の組をカードとします。
        - 5枚のカードを半角スペースで区切った文字列を1つのセットとします。
            - 例: S1 H3 H4 D9 C13
        - ジョーカーは無く、使用可能なカードは各スートの1から13の計52枚とします。
    - 役の仕様は一般的なポーカーのルールに準じます。
        - ただし、ロイヤルストレートフラッシュはありません。
    - Web画面とREST APIの両方からリクエストを受けられるようにしてください。

### Web

- 入力値からポーカーの役を判定し、役名を表示するWebページを作成してください。
    - ブラウザのフォームから1セットのカード情報を受け取ります。
    - 対応するポーカーの役を返却して画面上に表示します。
    - エラーで判定できなかった場合は、エラーメッセージを表示してください。

### API

- 複数のカード情報をリクエストし、それらに対応する役と最も強い役の情報を返却してください。
- 同一の役であれば同じ強さとし、スートや数字は強弱を決める際に考慮しない仕様とします。
- 役の判定ができなかった場合はエラーメッセージを返却してください。
- APIは最低限、以下の仕様に則ってください。機能要件を満たしていれば、パラメータ名は自由です。
    - HTTP/POST形式でリクエスト
    - headerに`CONTENT_TYPE=”application/json”`を指定

### Contract

- アプリケーションはRuby on Railsを使って構築してください。
- Web画面とREST APIで共通で使うビジネスロジックは1箇所にまとめて汎化させてください。
- Rubyのテストフレームワーク「RSpec」でテストコードを書き、全てパスさせてください。
    - Web画面、REST API共にRSpec:Requestでテストコードを書いてください。
    - 共通のビジネスロジックについてもテストコードを書いてください。（形式は任意）

<br />
説明は以上です。では、健闘を祈ります！ガンバって✊

<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<div style="text-align: center; font-weight: bold"">・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・</div>
<div style="text-align: center; font-weight: bold">⚠️ 注意：ここから下には「答え」が書いてあります 👇👇👇</div>
<div style="text-align: center; font-weight: bold"">・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・・</div>
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />

## 🙈 Demo (One Answer)

### Web

http://p0kerhands.herokuapp.com

![操作方法：Web画面](https://i.gyazo.com/b21cc57e96aa5582016d05080710bb06.gif)

### API

http://p0kerhands.herokuapp.com/api/v1/cards/check

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

## 🔨 For Development

1. はじめにGitからコードを取得（`git clone <repository URL>`）します。
2. 必要なライブラリをbundlerを使ってインストール（`bundle install`） します。
    1. 事前に`gem install bundler`でbundlerをインストールしておいてください。
3. Railsアプリケーションを起動（`rails s`）してWeb画面/APIにアクセスできます。

## ⚙️ Versions

- Rails 6.1.2
- Ruby 3.0.0

[Heroku]: https://jp.heroku.com/

[Cloudflare]: https://www.cloudflare.com/ja-jp/
