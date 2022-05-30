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
      # yum update
      is_yumupdate=true
      if "${is_yumupdate}" ; then echo "yum update..." ; yum update -y ; fi

      # set timezone
      if [[ ! $( timedatectl 2>/dev/null | grep -Ei "Time Zone.*Asia/Tokyo" ) ]] ; then echo "set timezone..." ; timedatectl set-timezone Asia/Tokyo ; fi
      echo "timezone is $(timedatectl 2>/dev/null | grep -E 'Time zone.*')"

      # Web Server Install
      if [[ ! $( which httpd 2>/dev/null ) ]] ; then yum install -y httpd ; fi
      if [[ ! $( systemctl list-units --type=service 2>/dev/null | grep -i "httpd.service" ) ]] ; then systemctl enable httpd.service ; fi
      systemctl start httpd.service
      sleep 0.5
      echo "httpd status is $(systemctl status httpd 2>/dev/null | grep -E Active:.*)"
      if [[ ! $( systemctl status httpd 2>/dev/null | grep -E Active:.* | grep -i "running" ) ]] ; then echo "httpd is not running."; exit 1 ; fi

      # Web Contents
      echo "Test Page" > /var/www/html/index.html
      sleep 0.5
      echo "http response is..."
      echo "$(curl -I http://localhost)"

      # Rename Computer
      if [ "$(hostname)" != ${TAGNAME} ] ; then
        echo "rename computer name..."
        hostnamectl set-hostname ${TAGNAME}
        if [ ! $(cat /etc/cloud/cloud.cfg 2>/dev/null | grep -i preserve_hostname) ] ; then
          echo "preserve_hostname: true" >> /etc/cloud/cloud.cfg
        else
          sed -i 's/preserve_hostname.*/preserve_hostname: true/g' /etc/cloud/cloud.cfg
        fi
      fi
      echo "computer name is $(hostname)"
    fi
  else
    echo "Amazon Linux 2 only support."
    exit 1
  fi
else
  echo "Amazon Linux 2 only support."
  exit 1
fi
