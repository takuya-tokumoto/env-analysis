# 目的

- どんな環境でもdockerを用いてクイックにデータ分析用の環境構築を実行することが目的

# セットアップ
## dockerをインストール
### docker desktopをインストールする場合
- [ここ](https://docs.docker.com/desktop/)などを参考にdocker desktopをインストール

### CLIでインストールする場合
- ec2でubuntuインスタンスを立ち上げた場合などを想定
```shell
sudo apt-get update
sudo apt-get install docker.io
sudo gpasswd -a {ユーザ名:ubuntu} docker
docker --version #表示されればセットアップ完了
exit #gpasswdでユーザを付与した後に再ログイン必要
```

## git clone
```shell
git clone https://github.com/takuya-tokumoto/env-analysis.git
cd env-analysis
```

## dorkerの起動して環境構築

```shell
./build.sh
./run.sh #windows環境の場合は run_for_win.sh を実行
```

## jupyterlabへアクセス

- ローカルPCで立ち上げた場合はブラウザから`locathost:8888`
- EC2の場合はブラウザから`{パブリック IPv4 DNS}:8888`


## 備考
- テスト環境
  - ローカルPC(OS:windows)
  - EC2(AMI:ubuntu server 22.04 LTS(HUM), instancetype:c5.2xlarge, EBS:100GB)
