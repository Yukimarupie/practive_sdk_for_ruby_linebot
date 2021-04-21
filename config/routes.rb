Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'hello/index'

  #LINEプラットフォームから送信されるリクエストをRailsアプリが受け取るためのルーティング
  #line_botコントローラーのcallbackアクションのルーティングをリクエスト処理のためのルーティングとして設定
  post '/callback' => 'line_bot#callback'
end
