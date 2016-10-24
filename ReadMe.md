# このソフトウェアについて #

GiHubApi.Repositories.Create.201610232026は私個人が学習目的で作成したソフトウェアである。

GitHubリポジトリを生成するバッチ。プロジェクトディレクトリに入れるバッチにAccessTokenを含まぬようにした。

# 前回まで

日時|リポジトリ|説明
----|----------|----
2016/10/17|[Edit](https://github.com/ytyaru/GiHubApi.Repositories.Edit.201610171352)|リモートリポジトリの説明やHomepageを修正する
2016/10/17|[Delete](https://github.com/ytyaru/GiHubApi.Repositories.Delete.201610171215)|リモートリポジトリを削除する。実行確認を付与した。
2016/10/14|[Create](https://github.com/ytyaru/GiHubApi.Repositories.Create.201610140807)|リモートリポジトリを生成するバッチ。
2016/10/01|[CreateRepository](https://github.com/ytyaru/CreateRepository201610012001)|ローカルとリモートのリポジトリを作成するバッチ＆シェル。
2016/10/01|[CreateRemoteRepository](https://github.com/ytyaru/CreateRemoteRepository201610011955)|リモートリポジトリを生成するバッチ＆シェル。

# 開発環境 #

* Windows XP Pro SP3 32bit
    * cmd.exe
* [curl.exe](https://curl.haxx.se/download.html#Win32)
    * 7.24.0
* [q.exe](http://harelba.github.io/q/ja/index.html)
    * 1.5.0
* sleep.exe
    * msys
        * [mingw-get-setup.exe](https://sourceforge.net/projects/mingw/files/latest/download?source=files)でインストールする

## WebService ##

* [GitHub](https://github.com/)
    * [AccessToken](https://github.com/settings/tokens)
        * scopeに`repo`をチェックする

# ライセンス #

このソフトウェアはCC0ライセンスです。

[![CC0](http://i.creativecommons.org/p/zero/1.0/88x31.png "CC0")](http://creativecommons.org/publicdomain/zero/1.0/deed.ja)
