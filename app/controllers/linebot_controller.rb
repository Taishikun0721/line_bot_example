class LinebotController < ApplicationController
  require 'line/bot'
  protect_from_forgery :except => [:callback]
  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          reply = LineBot::TemplateMessage.quick_reply
          client.reply_message(event['replyToken'], reply)
        when Line::Bot::Event::MessageType::Location
          location = Grunavi::RequestLocation.new(event.message.dig('latitude'), event.message.dig('longitude'))
          res = location.send
          template = LineBot::TemplateMessage.new(res)
          reply = if template.error?
                    template.error_message
                  else
                    template.carousel
                  end
          client.reply_message(event['replyToken'], reply)
        end
      end
    }

    head :ok
  end


  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_ACCESS_TOKEN"]
    }
  end
end
