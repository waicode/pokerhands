![pokerhands](http://p0kerhands.herokuapp.com/image/logo.png "pokerhands")
====

スート（S,H,D,C）と数字（1～13）の組み合わせで構成された5枚のカード文字列（例: "S10 H11 D12 C13 H1"）を受け取り、ポーカーの役を判定するアプリケーションです。JORKERには対応していません。

## Description

### Web
ブラウザのフォームから1セットのカード情報を受け取り、
対応する役を返却して画面上に表示します。

### API
複数のカード情報をリクエストし、それらに対応する役と最も強い役の情報を返却します。
同一の役であれば同じ強さとし、スートや数字は考慮しません。

## Demo

### Web
http://p0kerhands.herokuapp.com

### API
http://p0kerhands.herokuapp.com/api/v1/cards/check
+ メソッド：POST
+ ヘッダーに CONTENT_TYPE="application/json" を指定
+ ボディに含まれるJSONは以下の形式でカード文字列の配列を指定
  + { "cards": ["S1 S2 D3 S4 S5", "S1 C1 D1 H1 S5", "S11 S12 D7 S7 H7"] }
