# Cloud Formation Development<!-- omit in toc -->

テンプレートファイルの開発を行います.

```bash
VSCode起動
> cd [ローカルレポジトリ]
> code .
```

Cloud Formation 入力するのが手間なので、以下、Cfnと記述します.

## What is Cfn?

Templateファイル(抽象的)から

スタック(実体・リソース)を

作成します.

同じテンプレートファイルで異なる名前のスタックを作成すると、同じものが2つできる柴田大知と柴田未崎のような双子関係になります.なので、本番・ステージングやBlue＆GreenDeployなど