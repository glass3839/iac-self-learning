#!/bin/bash
if [ -f /etc/system-release ] ; then                                                # /etc/system-releaseファイル有無チェック(rhel,debian系OS選別)
  if [[ $( cat /etc/system-release | grep -i "Amazon Linux release 2" ) ]] ; then   # amazon linux 2のみ.
    # 自身の名前タグを参照するためのコマンドインストールチェック
    if [[ ! $( which curl 2>/dev/null ) ]] ; then yum install -y curl ; fi
    if [[ ! $( which aws 2>/dev/null ) ]] ; then yum install -y awscli ; fi
    # 自身の名前タグ取得(IMDSv2対応). 間違えて意図しないEC2にRunComandを実行してしまった場合の回避策.
    TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
    TAGNAME=`curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/tags/instance/Name`
    echo "tag name is ${TAGNAME} ..."
    if [ $TAGNAME == "sam-app-stg" ] ; then # *** sam-app-stg"を実際のEC2のタグ名に変更してください ***
      is_yumupdate=true
      if [ "${is_yumupdate}" ] ; then echo "yum update..." ; yum update -y ; fi

      # Web Server Install
      if [[ ! $( which httpd 2>/dev/null ) ]] ; then yum install -y httpd ; fi
      if [[ ! $( systemctl list-units --type=service 2>/dev/null | grep -i "httpd.service" ) ]] ; then systemctl enable httpd.service ; fi
      systemctl start httpd.service
      echo "httpd status is ..."
      systemctl status httpd 2>/dev/null | grep -E Active:.*
      if [[ ! $( systemctl status httpd 2>/dev/null | grep -E Active:.* | grep -i "running" ) ]] ; then echo "httpd is not running."; exit 1 ; fi

      # Web Contents
      echo "Test Page" > /var/www/html/index.html

      # Rename Computer
      if [ "$(hostname)" != ${TAGNAME} ] ; then echo "rename computer name..."; hostnamectl set-hostname ${TAGNAME} ; fi
      
    fi
  else
    echo "Amazon Linux 2 only support."
    exit 1
  fi
else
  echo "Amazon Linux 2 only support."
  exit 1
fi

