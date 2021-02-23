class LineBot::TemplateMessage

  attr_reader :api_params
  def initialize(api_params)
    @api_params = api_params
  end

  def carousel
    {
        "type": "template",
        "altText": "this is a carousel template",
        "template": {
            "type": "carousel",
            "columns": carousel_inner(api_params.dig('rest')),
            "imageAspectRatio": "rectangle",
            "imageSize": "cover"
        }
    }
  end

  def error_message
    {
        type: "text",
        text: api_params.dig('error', 0, 'message')
    }
  end

  def self.quick_reply
    {
        "type": "text",
        "text": "位置情報ボタンを押してください",
        "quickReply": {
            "items": [
                {
                    "type": "action",
                    "action": {
                        "type": "location",
                        "label": "位置情報を送る",
                    }
                }
            ]
        }
    }
  end

  def error?
    api_params.include?('error')
  end

  private

  def carousel_inner(api_params)
    result = []

    api_params.each do |params|
      result << {
          "thumbnailImageUrl": image(params),
          "imageBackgroundColor": "#000000",
          "title": params["name"],
          "text": text_inner(params),
          "defaultAction": {
              "type": "uri",
              "label": "View detail",
              "uri": params["url"]
          },
          "actions": [
              {
                  "type": "uri",
                  "label": "View detail",
                  "uri": params["url"]
              }
          ]
      }
    end
    result
  end

  def image(params)
    image = "https://example.com/bot/images/item1.jpg"
    image = params["image_url"]["shop_image2"] if params["image_url"]["shop_image2"].present?
    image = params["image_url"]["shop_image1"] if params["image_url"]["shop_image1"].present?
    image
  end

  def text_inner(params)
    "カテゴリー: #{params["category"]}" + "\n" + "予算: #{params["budget"]}円" + "\n" + "徒歩での距離: #{params["access"]["line"] + params["access"]["station"]}から#{params["access"]["walk"]}分"
  end
end

