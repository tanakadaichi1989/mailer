## Railsでメール送信機能を実装する方法
![スクリーンショット 2018-01-20 19.57.53.png](https://qiita-image-store.s3.amazonaws.com/0/199441/f1440fb4-0d1b-6355-a342-ca3f45809e39.png)

### ポイント
Railsの１機能である`Mailer`を利用する

### 実装方法
ここでは、Railsアプリ`mailer`にメール送信機能を実装していく。

#### 1. scaffoldで、モデル・ビュー・コントローラを実装

```command:command
$ rails new mailer
$ cd mailer
$ rails g scaffold User name:string email:string
```
#### 2. コマンドで**UserMailer**を実装
```command:command
$ rails g mailer UserMailer send_mail
```

#### 3. **UserMailer**を編集
```ruby:app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer

def send_mail(user)
@user = user
mail to: user.email, subject:"Sample from Rails"
end
end
```

#### 4. **users_controller**を編集
ここでは、新しくユーザー情報が登録されたらメールを送信するようにする。

createアクションに`UserMailer.send_mail(@user).deliver_now`を追加

```ruby:app/controllers/users_controller.rb
class UsersController < ApplicationController

#...省略...

def create
@user = User.new(user_params)

respond_to do |format|
if @user.save

##追加したコード
UserMailer.send_mail(@user).deliver_now

format.html { redirect_to @user, notice: 'User was successfully created.' }
format.json { render :show, status: :created, location: @user }
else
format.html { render :new }
format.json { render json: @user.errors, status: :unprocessable_entity }
end
end
end

#...省略...
end
```

#### 5. メール本文を作成
```command:command
mailer $ cd app/views/user_mailer
user_mailer cd touch send_mail.html.erb send_mail.txt.erb
```

```html+erb:app/views/user_mailer/send_mail.html.erb
<h1>Dear <%= @user.name %></h1>

<p>
Thank you to join our app.
</p>
```

```text+erb:app/views/user_mailer/send_mail.txt.erb
Dear <%= @user.name %>
Thank you to join our app.
```


#### 6. **app/enviroments/development.rb** を編集
```ruby:development.rb
Rails.application.configure do

# ..省略..

config.action_mailer.raise_delivery_errors = true
#デフォルトではfalseになっている

config.action_mailer.delivery_method = :smtp

config.action_mailer.smtp_settings = {
port: 587,
address: 'smtp.gmail.com',
domain: 'smtp.gmail.com',
user_name: YOUR_GMAIL_ADDRESS,
password: GOOGLE_APP_PASSWORD,
enable_starttls_auto: true
}

# ..省略..
```

## 実行結果

#### 下記コマンドを入力して、プログラミングを実行

```command:command
$ cd mailer
$ rails s
```

#### 下記アドレスにアクセス
http://localhost:3000/users/new

#### Nameに名前を、Emailにメールアドレスを入力 & [Create User]をクリック
![スクリーンショット 2018-01-20 20.42.55.png](https://qiita-image-store.s3.amazonaws.com/0/199441/9a7502c0-3c92-f13b-2b55-4bfd850e7ca8.png)

#### Gmailを確認
下記のように、メールが届いていることがわかる。

![スクリーンショット 2018-01-20 20.50.27.png](https://qiita-image-store.s3.amazonaws.com/0/199441/df342df3-b5ed-4664-47c6-fd330a179c05.png)

## 参考資料
[Ruby on Rails チュートリアル 第11章](https://railstutorial.jp/chapters/account_activation?version=5.1#sec-account_activation_emails)

