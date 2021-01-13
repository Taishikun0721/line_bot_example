class LineBot::TemplateMessage

  attr_reader :shops_information
  def initialize(shops_imformation)
    @shops_information = shops_imformation
  end

  def carousel
    {
        "type": "template",
        "altText": "this is a carousel template",
        "template": {
            "type": "carousel",
            "columns": insert_carousel_inner(shops_information["rest"]),
            "imageAspectRatio": "rectangle",
            "imageSize": "cover"
        }
    }
  end

  def error_message
    {
        type: "text",
        text: shops_information["error"][0]["message"]
    }
  end

  def error?
    shops_information.include?('error')
  end

  private

  def insert_carousel_inner(shops_information)
    result = []

    shops_information.each do |params|
      result << {
          "thumbnailImageUrl": image_select(params),
          "imageBackgroundColor": "#000000",
          "title": params["name"],
          "text": params["category"],
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

  def image_select(params)
    image = "https://example.com/bot/images/item1.jpg"
    image = params["image_url"]["shop_image2"] if params["image_url"]["shop_image2"].present?
    image = params["image_url"]["shop_image1"] if params["image_url"]["shop_image1"].present?
    image
  end
end

