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
            "columns": insert_carousel_inner(shops_information),
            "imageAspectRatio": "rectangle",
            "imageSize": "cover"
        }
    }
  end

  private

  def insert_carousel_inner(shops_information)
    result = []

    shops_information.each do |params|
      result << {
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
end

