# Cloud Formation<!-- omit in toc -->

## 1. VPCを作る

### 1.1. VPCの設計図(テンプレートファイル)を作る

#### 1.1.1. レポジトリにcfnフォルダを作成し、template.ymlファイルを作成します

```bash
VSCode起動
> cd [ローカルレポジトリ]
> code .
```

VsCode上で、`Ctrl + Shift + @`を押すと、ターミナルが起動します.

```bash
> python -m pipenv shell # Python仮想環境のShellに切り替え
Launching subshell in virtual environment...

> mkdir cfn
> cd cfn
cfn> touch template.yml
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

    Parameter: Googleで[cfn パラメータ]でリファレンスを検索してください.リスト選択など、入力値のValidation方法などを調べます.

    Resource: Googleで[cfn サービス名(やAWS::EC2::VPC)]でリファレンスを検索してください.プロパティの書き方,必須入力値や戻り値などを調べます.

    擬似パラメータ: Googleで[cfn 擬似パラメータ]でリファレンスを検索してください.AWSアカウントやリージョンにしばられないテンプレートファイル作りなどで使います.

#### 1.1.2. VPC作成(スタック作成)

```bash
cfn> sam build       # cfnフォルダにtemplate.ymlファイルがあれば、Buildしてくれる
Build Succeeded
Built Artifacts  : .aws-sam\build
Built Template   : .aws-sam\build\template.yaml
Commands you can use next
=========================
[*] Validate SAM template: sam validate
[*] Invoke Function: sam local invoke
[*] Test Function in the Cloud: sam sync --stack-name {stack-name} --watch
[*] Deploy: sam deploy --guided
```

```bash
cfn> sam deploy -g   # Buildしたテンプレファイルを展開してくれる(初回は、「-g」パラメータ入力が必須)
Configuring SAM deploy
======================
        Looking for config file [samconfig.toml] :  Not found
        Setting default arguments for 'sam deploy'
        =========================================
        Stack Name [sam-app]: miya-stack                # CloudFormation スタック名を入力
        AWS Region [ap-northeast-1]: ap-northeast-3     # スタックを作成するリージョン名
        Parameter VpcCidr [10.0.0.0/22]: 10.0.0.0/22    # テンプレートに作成したパラメータ
        Confirm changes before deploy [y/N]:            # デプロイ前に変更点の確認するか
        Allow SAM CLI IAM role creation [Y/n]:          # SAM CLI から IAMロールを作成することを許可するか
        Capabilities [['CAPABILITY_IAM']]:              # IAM名指定やネストスタックを利用する場合、CAPABILITY_NAMED_IAM、CAPABILITY_AUTO_EXPANDを指定する
        Disable rollback [y/N]:                         # スタック作成に失敗した場合、Rollbackの有効・無効の選択
        Save arguments to configuration file [Y/n]:     # 入力した値をConfigファイルに保存するか
        SAM configuration file [samconfig.toml]:        # Configファイル名指定
        SAM configuration environment [default]:        # Configu環境名指定

CloudFormation stack changeset                          # ChangesetでVPCが追加させることがわかる
---------------------------------------------------------------------------------------------------------
Operation                  LogicalResourceId          ResourceType               Replacement
---------------------------------------------------------------------------------------------------------   
+ Add                      Vpc                        AWS::EC2::VPC              N/A
---------------------------------------------------------------------------------------------------------

CloudFormation events from stack operations             # スタック作成のログ
---------------------------------------------------------------------------------------------------------
ResourceStatus             ResourceType               LogicalResourceId          ResourceStatusReason       
---------------------------------------------------------------------------------------------------------   
CREATE_IN_PROGRESS         AWS::EC2::VPC              Vpc                        -
CREATE_IN_PROGRESS         AWS::EC2::VPC              Vpc                        Resource creation        
                                                                                 Initiated
CREATE_COMPLETE            AWS::EC2::VPC              Vpc                        -
CREATE_COMPLETE            AWS::CloudFormation::Sta   miya-stack                 -
                           ck
---------------------------------------------------------------------------------------------------------   

Successfully created/updated stack - miya-stack in ap-northeast-3
```
