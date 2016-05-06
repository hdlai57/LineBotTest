class ConvosController < ApplicationController

  def index
    @convos = Convo.all
  end

  def new
    @convo = Convo.new
  end

  def create
    convo = Convo.new(convo_params)
    if convo.save!
      redirect_to convos_path
    else
      render :new
    end
  end

# Line bot
  def callback 
    signature = request.env['HTTP_X_LINE_CHANNELSIGNATURE']
    unless client.validate_signature(request.body.read, signature)
      error 400 do 'Bad Request' end
    end

    receive_request = Line::Bot::Receive::Request.new(request.env)

    receive_request.data.each { |message|
      case message.content
      when Line::Bot::Message::Text
        client.send_text(
          to_mid: message.from_mid,
          text: message.content[:text],
        )
      end
    }

    "OK"
  end


  private

  def convo_params
    params.require(:convo).permit(:text)
  end

# Line bot
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_id = ENV["1466651784"]
      config.channel_secret = ENV["7f17a78e95948a22dc93b3ce67c4e9cb"]
      config.channel_mid = ENV["u8c29ad707a807c0ffa82ade5a670e110"]
    }
  end


end