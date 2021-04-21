class LineBotController < ApplicationController
  require 'line/bot'

  #Line Botの処理のみ実施するようなアプリの場合はCSRF攻撃のリスクはほぼない。のでCSRF対策を無効化するコードを記述
  protect_from_forgery except: [:callback]

  def callback
    body = request.body.read
  # 悪意のあるサーバーからのリクエストを受信しないように、署名を検証する
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      return head :bad_request
    end

    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    end
    head :ok
  end

  private
 # クラス外からはアクセスできないことを表すアクセス修子
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
  # ||=は左辺がnilやfalseの場合、右辺を代入するという意味
end
