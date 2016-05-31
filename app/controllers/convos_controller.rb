class ConvosController < ApplicationController
  before_action :client

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
          text: message.content[:text] + " --- by Pu <3 @ 531",
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
      # binding.pry
      config.channel_id = ENV["LINEPUBOT_ID"]
      config.channel_secret = ENV["LINEPUBOT_SECRET"]
      config.channel_mid = ENV["LINEPUBOT_MID"]

    }
  end


end