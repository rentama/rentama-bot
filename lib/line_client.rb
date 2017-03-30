class LineClient
  END_POINT = "https://api.line.me"

  def initialize(channel_access_token, proxy = nil)
    @channel_access_token = channel_access_token
    @proxy = proxy
  end

  def post(path, data)
    client = Faraday.new(:url => END_POINT) do |conn|
      conn.request :json
      conn.response :json, :content_type => /\bjson$/
      conn.adapter Faraday.default_adapter
      conn.proxy @proxy
    end

    res = client.post do |request|
      request.url path
      request.headers = {
        'Content-type' => 'application/json',
        'Authorization' => "Bearer #{@channel_access_token}"
      }
      request.body = data
    end
    res
  end

  def reply(replyToken, text, event_type)
    case event_type
    when "message"
      input_text = change_text(text)
    when "sticker"
      input_text = "スタンプやんけ"
    end

    messages = [
      {
        "type" => "text" ,
        "text" => input_text
      }
    ]

    body = {
      "replyToken" => replyToken ,
      "messages" => messages
    }
    post('/v2/bot/message/reply', body.to_json)
  end

  def change_text(text)
    if text.match(/けもの/)
      "スゴーーーーーイ！！君はけものフレンズなんだね！"
    else
      natto = Natto::MeCab.new
      word = ""
      natto.parse(text) do |n|
        word = n.surface if n.surface.length >= word.length && n.feature.match(/名詞/)
      end
      "スゴーーーーーイ！！君は#{word}フレンズなんだね！"
    end
  end

end
