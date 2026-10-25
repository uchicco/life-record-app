# くらしの記録（独立サイト版）

このフォルダを既存の `myblog` に入れず、アプリ専用フォルダ・GitHubリポジトリ・GitHub Pagesサイトとして公開します。

## ファイル

- `index.html`：アプリ本体
- `manifest.webmanifest`：iPhone/Windowsへのインストール設定
- `sw.js`：オフライン起動用
- `setup-supabase.sql`：クラウド同期用テーブルと権限設定

## 1. Windowsにアプリ専用フォルダを作る

ZIPを展開し、中の5ファイルを次のフォルダに入れます。

`C:\Users\nuich\Documents\life-record-app`

`life-record-app` フォルダがなければ作成します。`index.html` などがこの直下に並ぶようにします。

## 2. GitHubに専用リポジトリを作る

1. GitHubで `https://github.com/new` を開きます。
2. Repository name に `life-record-app` と入力します。
3. Public を選びます。アプリのコードは公開されますが、記録データはSupabaseの本人専用権限で保護します。
4. READMEやファイルは追加せずに **Create repository** を押します。

## 3. 専用リポジトリへアップロードする

PowerShellを開き、次を1行ずつ実行します。

```powershell
cd "$env:USERPROFILE\Documents\life-record-app"
git init
git branch -M main
git add .
git commit -m "Create life record app"
git remote add origin https://github.com/uchicco/life-record-app.git
git push -u origin main
```

GitHubの認証画面が出たら案内に従います。

## 4. GitHub Pagesを有効にする

1. 新しい `uchicco/life-record-app` リポジトリを開きます。
2. **Settings → Pages** を開きます。
3. **Build and deployment** の Source で **Deploy from a branch** を選びます。
4. Branch は `main`、フォルダは `/(root)` を選び、**Save** を押します。
5. 1〜数分待ち、同じPages画面に表示される公開URLを開きます。

通常のURLは `https://uchicco.github.io/life-record-app/` です。公開後、これをWindowsとiPhoneの両方で使います。

## 5. Supabaseで同期を設定する

アプリは以前使っていたSupabase Project URLを初期表示します。プロジェクトが引き続き利用できる場合はそのまま使えます。別のプロジェクトを使う場合は、そのProject URLに置き換えてください。

1. Supabase Dashboardで該当プロジェクトを開きます。
2. **SQL Editor → New query** を開きます。
3. このフォルダの `setup-supabase.sql` をメモ帳で開き、全文をコピーしてSQL Editorに貼り付けます。
4. **Run** を押します。成功すると同期用 `life_record_data` テーブルが作られます。
5. Supabaseの **Connect** 画面、または **Project Settings → API Keys** からProject URLとPublishable keyをコピーします。`anon` keyも利用できます。`sb_secret_...` や `service_role` はアプリに入力しないでください。
6. **Authentication → URL Configuration → Redirect URLs** に `https://uchicco.github.io/life-record-app/` を追加します。Site URLは変更せずに使えます。
7. 公開したアプリの **設定** を開き、Project URLとPublishable / anon keyを入力して **接続設定を保存** します。
8. メールアドレスとパスワードでアカウント登録します。確認メールが届いたらリンクを開き、アプリに戻ってログインします。

Supabaseで確認メールが有効なら、メールを確認してからアプリにログインしてください。URL Configurationに戻り先を追加すると、新規登録メールがこのアプリに戻ります。

## 6. iPhone 15・Windowsで使う

- **iPhone 15**：Safariで公開URLを開く → 共有 → **ホーム画面に追加**。追加したアイコンから起動します。
- **Windows**：ChromeまたはEdgeで公開URLを開く。同じSupabase URL・キーとログイン情報を設定し、アプリとしてインストールできます。

同じアカウントでログインすると変更後およそ1.3秒で同期します。同期前に両端末のデータが別々に変わっていた場合は、設定画面でどちらを使うか選択します。選んだ側のデータが同期先になり、置き換え前の記録はJSONファイルとしてダウンロードされます。

## データについて

Project URLとPublishable/anon key、ログインセッションは各ブラウザ内に保存されます。パスワードは保存しません。同期を使うと記録データはSupabaseに保存されます。SQLは認証ユーザーが自分の記録だけを読めるように設定します。同期前の手動バックアップはアプリの **設定 → 全データをバックアップ** から行えます。
