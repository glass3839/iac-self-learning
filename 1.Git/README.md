# Git<!-- omit in toc -->

テンプレートファイルをCodeCommitを利用して管理します.

```bash
VSCode起動
> cd [ローカルレポジトリ]
> code .
```

VsCode上で、`Ctrl + Shift + @`を押すと、ターミナルが起動します.

## Git Ignore

`.gitignore`ファイルに管理したくないパスを記載して、レポジトリから除外します.

今回、除外したいもの
- `sam build`で毎度生成されるので`.aws-sam/`フォルダは、管理対象外とします.
- `sam deploy`で生成される`samconfig.toml`ファイルは、管理対象外とします.

```bash
> touch .gitignore
> echo "*/.aws-sam/" >> .gitignore
> echo "*/samconfig.toml" >> .gitignore
```

`.gitignore`ファイルの中身

```text
*/.aws-sam/
*/samconfig.toml
```

VsCodeでは、除外ファイル・フォルダはグレー表示されます.

## Stage

変更をCommitするファイルを追加するエリアのこと.ステージングエリアと言うらしいです.

 ```bash
 > git add [ファイルパス] # 全てのファイルをステージングエリアに追加する場合は、「.」を指定.
 ```
 

## 1. Git Push

先に作成したテンプレートファイルをCodeCommitにPush(Upload)します.

Pushする前に、

- `sam build`で毎度生成されるので`.aws-sam/`フォルダは、管理対象外とします.
- `sam deploy`で生成される`samconfig.toml`ファイルは、管理対象外とします.

`.gitignore`ファイルを作成し、`*/.aws-sam`と`*/samconfig.toml`を追記し、管理対象外にします.



