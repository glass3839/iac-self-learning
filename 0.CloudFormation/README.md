# Cloud Formation<!-- omit in toc -->

## 1. VPCを作る

### 1.1. VPCの設計図(テンプレートファイル)を作る

#### 1.1.1. レポジトリにcfnフォルダを作成し、template.ymlファイルを作成します.

```bash
> cd [ローカルレポジトリ]
> code .
> mkdir cfn
> touch template.yml
```

- template.yml

    ```yaml
    AWSTemplateFormatVersion: '2010-09-09'  # 宣言文のようなもの
    Transform: AWS::Serverless-2016-10-31   # aws sam cliを利用するために必要
    Description: >                          # 説明文
        First Cloud Formation
    Parameters:                             # スタック作成時の入力パラメータ
      VpcCidr:                              # パラメータ名
        Description: Cidr block for vpc.    # パラメータ説明文
        Type: String                        # パラメータ型
        Default: 10.0.0.0/22                # 初期値
    Resources:                              # AWSリソースブロック
      Vpc:                                  # リソース論理名
        Type: AWS::EC2::VPC                 # リソースの識別
        Properties:                         # リソースプロパティブロック
          CidrBlock: !Ref VpcCidr           # 変数 VpcCidrで指定された値
          Tags:
          - Key: Name
            Value: !Ref AWS::StackName      # 擬似パラメータ: スタック名
    ```

    3行目までは、このような書き方が必要なんだと覚えてください。

    Parameter: Googleで[cfn パラメータ]でリファレンスを検索してください.リスト選択など、ユーザーフレンドリな入力補助ができないかなどを調べます.

    Resource: Googleで[cfn サービス名(やAWS::EC2::VPC)]でリファレンスを検索してください.プロパティの描き方,必須入力値や戻り値などを調べます.

    擬似パラメータ: Googleで[cfn 擬似パラメータ]でリファレンスを検索してください.AWSアカウントやリージョンにしばられないテンプレートファイル作りなどで使います.

#### 1.1.2. VPC作成(スタック作成)

```bash
> cd [ローカルレポジトリ]
> cd cfn
> sam build       # cfnフォルダにtemplate.ymlファイルがあれば、Buildしてくれる
> sam deploy -g   # Buildしたテンプレファイルを展開してくれる(初回は、「-g」パラメータ入力が必須)
```
