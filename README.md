# IaC Self Learning<!-- omit in toc -->

## Contents<!-- omit in toc -->
- [1. はじめに](#1-はじめに)
  - [1.1. ゴール](#11-ゴール)
  - [1.2. Iacメリット・デメリット](#12-iacメリットデメリット)
  - [1.3. IaCをやる理由](#13-iacをやる理由)
  - [1.4. 免責事項](#14-免責事項)
- [2. 開発環境構築](#2-開発環境構築)
  - [2.1. Require](#21-require)
  - [2.2. 設定](#22-設定)

## 1. はじめに

### 1.1. ゴール

- AWSサービスを使いこなして、Webサーバーを構築しコンテンツをデプロイを自動化する.

    <img src="./images/img.dio.png">

- IaCの開発ができるようになる.

### 1.2. Iacメリット・デメリット

- メリット
  - 手順書簡素化
  - 時間の有効活用(手順書見ながら作業不要なので、他のことに時間が使える)
  - 冪等性(誰がやっても同じ結果に) → 品質向上
- デメリット
  - 学習コスト(時間がかかる)
  - 開発コスト(時間)が高い、覚えなければならないことが沢山
  - 結局、デメリットの方が大きい

### 1.3. IaCをやる理由

- ITでご飯を食べて行くなら、やったほうがいいです。

  - Docker(K8S) → みんなが大好きボタンぽちぽちじゃないです。
  - CD/CI       → みんなが大好きボタンぽちぽちじゃないです。
  - サーバーレス  → そもそもInfra不要!?。

→ 環境定義署と手順書を見ながら手作業でやってた作業を自動化できるように英語にするのがIaCです。

### 1.4. 免責事項

本文書の情報については充分な注意を払っておりますが、その内容の正確性等に対して一切保障するものではありません.本文章の利用で発生したいかなる結果について、一切責任を負わないものとします.また、本文書のご利用により、万一、ご利用者様に何かしらの不都合や損害が発生したとしても、責任を負うものではありません.


## 2. 開発環境構築

### 2.1. Require

- [Python3.9](https://www.python.org/downloads/)
  - [パッケージのインストール必読](https://www.python.jp/install/windows/install.html)
- [git](https://git-scm.com/)
- [VisualStuioCode](https://code.visualstudio.com/download)

### 2.2. 設定

1. `pip`コマンドを実行して、`aws cli`をインストール

    ```bash
    python -m pip install pip --upgrade --user
    python -m pip install awscli --user
    ```

2. IAMユーザのアクセスキー・シークレットアクセスキーを発行

    <img src="./images/accesskey.png" width="384">

3. `aws configure`コマンドを実行して、`アクセスキー`,`シークレットアクセスキー`を設定

    ```bash
    aws configure
    AWS Access Key ID : [アクセスキー]
    AWS Secret Access Key : [シークレットキー]
    Default region name : ap-northeast-1
    Default output format : json
    ```