# IaC Self Learning<!-- omit in toc -->

## Contents<!-- omit in toc -->
- [1. はじめに](#1-はじめに)
  - [1.1. 目的](#11-目的)
  - [1.2. Iacメリット・デメリット](#12-iacメリットデメリット)
  - [1.3. それでも、IaCをやる理由](#13-それでもiacをやる理由)
  - [1.4. 表記について](#14-表記について)
  - [1.5. 免責事項](#15-免責事項)
- [2. 開発環境構築](#2-開発環境構築)
  - [2.1. Require](#21-require)
  - [2.2. 設定](#22-設定)
    - [2.2.1. `pip`コマンドを実行して、`aws cli`をインストール](#221-pipコマンドを実行してaws-cliをインストール)
    - [2.2.2. IAMユーザのアクセスキー・シークレットアクセスキーを発行](#222-iamユーザのアクセスキーシークレットアクセスキーを発行)
    - [2.2.3. `aws configure`コマンドを実行して、`アクセスキー`,`シークレットアクセスキー`を設定](#223-aws-configureコマンドを実行してアクセスキーシークレットアクセスキーを設定)
    - [2.2.4. CodeCommit(コード管理)レポジトリ作成](#224-codecommitコード管理レポジトリ作成)
    - [2.2.5. CodeCommit認証設定](#225-codecommit認証設定)
    - [2.2.6. 作業ディレクトリを作成後、レポジトリ クローン](#226-作業ディレクトリを作成後レポジトリ-クローン)
    - [2.2.7. Python仮想環境作成](#227-python仮想環境作成)
    - [2.2.8. VisualStudioCode(以下、VsCode)起動](#228-visualstudiocode以下vscode起動)
- [3. CloudFormation](#3-cloudformation)
  - [3.1. VPC](#31-vpc)

## 1. はじめに

### 1.1. 目的

- AWSサービスを使い、単純構成のWebサーバーを構築、デプロイを自動化し基本的なことを学び、IaCの開発・デバッグ・テストができるようになる.

    <img src="./images/img.dio.png">

    |Item|役割|
    |---|---|
    |git|CodeCommitとコードをやり取りするためのアプリ|
    |CodeCommit|コード管理.GithubやGitlabのAWS版|
    |CfnTemplate|Webサーバを構築するためのCloudFormationTemplateファイル|
    |Content|Web公開するコンテンツ(html)|
    |Python(boto3)|boto3: Pythonのモジュールでaws cliのPython版|
    |Document|EC2で動かすBATファイルのようなもの|
    |aws sam cli|PythonのモジュールでCloudFormationの拡張版.GUIより早くTry&Errorが可能|


### 1.2. Iacメリット・デメリット

- メリット
  - 手順書簡素化
  - 時間の有効活用(手順書見ながら作業不要なので、他のことに時間が使える)
  - 冪等性(誰がやっても同じ結果に) → 品質のむらがない
- デメリット
  - 学習コスト(時間がかかる)
  - 開発コスト(時間)が高い、覚えなければならないことが沢山
→ デメリットの方が大きいのでやる意味があるのが？正直、微妙.

### 1.3. それでも、IaCをやる理由

- Docker(K8S) → ボタンぽちぽちじゃないです.
- CD/CI       → ボタンぽちぽちじゃないです.
- サーバーレス  → そもそもInfra不要!?.

とモダンな開発は、GUIじゃないです

- 環境定義署をおこして、
- 手順書見ながら、
- スクショを切り貼り

するが私には面倒・・・。

### 1.4. 表記について

```text
ps> Powershellを示す
> おすきなTerminalでどうぞ
```

### 1.5. 免責事項

本文書の情報については充分な注意を払っておりますが、その内容の正確性等に対して一切保障するものではありません.本文章の利用で発生したいかなる結果について、一切責任を負わないものとします.また、本文書のご利用により、万一、ご利用者様に何かしらの不都合や損害が発生したとしても、責任を負うものではありません.

## 2. 開発環境構築

### 2.1. Require

- [Python3.9](https://www.python.org/downloads/)
  - [パッケージのインストール必読](https://www.python.jp/install/windows/install.html)
- [git](https://git-scm.com/)
  - Git Credential Managerはインストールしないこと.
- [VisualStuioCode](https://code.visualstudio.com/download)

### 2.2. 設定

#### 2.2.1. `pip`コマンドを実行して、`aws cli`をインストール

```bash
ps> python -m pip install pip --upgrade --user
ps> python -m pip install awscli --user
ps> python -m pip install pipenv --user
```

#### 2.2.2. IAMユーザのアクセスキー・シークレットアクセスキーを発行

<img src="./images/accesskey.png" width="384">

#### 2.2.3. `aws configure`コマンドを実行して、`アクセスキー`,`シークレットアクセスキー`を設定

```bash
aws configure
AWS Access Key ID : [アクセスキー]
AWS Secret Access Key : [シークレットキー]
Default region name : [リージョン]
Default output format : json
```

#### 2.2.4. CodeCommit(コード管理)レポジトリ作成

```bash
ps> aws codecommit create-repository --repository-name [レポジトリ名]
```

出力例

```bash
{
    "repositoryMetadata": {
        "accountId": "[アカウントID]",
        "repositoryName": "[レポジトリ名]",
        "cloneUrlHttp": "https://git-codecommit.[リージョン].amazonaws.com/v1/repos/[レポジトリ名]",
        "cloneUrlSsh": "ssh://git-codecommit.[リージョン].amazonaws.com/v1/repos[レポジトリ名]",
        "Arn": "arn:aws:codecommit:[リージョン]:[アカウントID]:[レポジトリ名]"
    }
}
```

#### 2.2.5. CodeCommit認証設定

```bash
ps> git config --global user.name [YOUR NAME]
ps> git config --global user.email [YOUR EMAIL ADDRESS]
ps> git config --global "credential.https://git-codecommit.*.amazonaws.com/v1/repos/[リポジトリ名].helper" '!aws codecommit credential-helper $@'
ps> git config --global "credential.https://git-codecommit.*.amazonaws.com/v1/repos/[リポジトリ名].UseHttpPath" true
```

#### 2.2.6. 作業ディレクトリを作成後、レポジトリ クローン

```bash
ps> $wkdir = "$env:userprofile/Documents/[フォルダ名]"
ps> if (!(Test-Path $wkdir)) { New-Item -Path $wkdir -ItemType Directory | Out-Null }
ps> Set-Location -Path $wkdir
ps> git clone https://git-codecommit.[リージョン].amazonaws.com/v1/repos/[レポジトリ名]
# Git Credential Managerが表示されたら、「キャンセル」
ps> Set-Location [レポジトリ名]
ps> Get-Location # ← ここに表示されるPathがローカルレポジトリと言います.
```

#### 2.2.7. Python仮想環境作成

```bash
> cd [ローカルレポジトリ]
> python -m pipenv --python 3.9
Creating a virtualenv for this project...
Pipfile: C:\Users\xxxxxxxx\Documents\work\[レポジトリ名]\Pipfile
Using C:/Users/xxxxxxxx/AppData/Local/Programs/Python/Python39/python.exe (3.9.10) to create virtualenv...
[====] Creating virtual environment...created virtual environment CPython3.9.10.final.0-64 in 21306ms
  creator CPython3Windows(dest=C:\Users\xxxxxxxx\.virtualenvs\[レポジトリ名]-wTKRaSAf, clear=False, no_vcs_ignore=False, global=False)
  seeder FromAppData(download=False, pip=bundle, setuptools=bundle, wheel=bundle, via=copy, app_data_dir=C:\Users\xxxxxxxx\AppData\Local\pypa\virtualenv)
    added seed packages: pip==22.0.4, setuptools==62.1.0, wheel==0.37.1
  activators BashActivator,BatchActivator,FishActivator,NushellActivator,PowerShellActivator,PythonActivator

Successfully created virtual environment!
Virtualenv location: C:\Users\xxxxxxxx\.virtualenvs\m[レポジトリ名]-wTKRaSAf
Creating a Pipfile for this project...
```

```bash
> cd [ローカルレポジトリ]
> python -m pipenv install aws-sam-cli
Installing aws-sam-cli...
Adding aws-sam-cli to Pipfile's [packages]...
Installation Succeeded
Pipfile.lock not found, creating...
Locking [dev-packages] dependencies...
Locking [packages] dependencies...
          Building requirements...
Resolving dependencies...
Success!
Updated Pipfile.lock (dc4449)!
Installing dependencies from Pipfile.lock (dc4449)...
  ================================ 1/1 - 00:00:00
To activate this project's virtualenv, run pipenv shell.
Alternatively, run a command inside the virtualenv with pipenv run.
```

#### 2.2.8. VisualStudioCode(以下、VsCode)起動

```bash
> cd [ローカルレポジトリ]
> code .
```

## 3. CloudFormation

### 3.1. [VPC](./0.CloudFormation/README.md)