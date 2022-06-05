import boto3
import os
import hashlib
from pathlib import Path
from botocore.exceptions import ClientError

ssm = boto3.client('ssm')

current_dir       = Path(__file__).parent
ssm_document_dir  = current_dir.joinpath('documents')
document_files    = os.listdir(ssm_document_dir)

for d in document_files:
  document_name = os.path.splitext(d)[0]
  try:
    with open(ssm_document_dir.joinpath(d), encoding='utf-8') as f:
      # DocumentにUpload
      content       = f.read()
      content_hash  = hashlib.sha256(content.encode()).hexdigest()
      ssm.create_document(Name=document_name, DocumentType='Command', DocumentFormat='YAML', Content=content)
  except ClientError as e:
    if e.response['Error']['Code'] == 'DocumentAlreadyExists':
      # 同名Documentが存在ずる場合、コンテンツ内容を比較. 差分あり:更新、差分なし:スキップ.
      document = ssm.describe_document(Name=document_name)['Document']
      document_version = document['DocumentVersion']
      document_hash = document['Hash']
      if (content_hash != document_hash):
        try:
          response = ssm.update_document(Name=document_name, Content=content, DocumentVersion='$LATEST')['DocumentDescription']['DocumentVersion']
          ssm.update_document_default_version(Name=document_name, DocumentVersion=response)
        except ClientError as e:
          print(f'Err: {d} {e}')
        else:
          print(f'Inf: {d} updated.')
      else:
        print(f'Inf: {d} No Action.')
  else:
    print(f'Inf: {d} installed.')
