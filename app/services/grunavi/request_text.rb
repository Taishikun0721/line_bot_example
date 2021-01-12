class Grunavi::RequestText

  attr_reader :text
  def initialize(text)
    @text = text
  end

  def send
    uri = URI.parse(Settings.grunavi_end_point[:url] + '?' + URI.encode_www_form(search_params))
    string_responce_body = Net::HTTP.get_response(uri).body
    responce_body = JSON.parse(string_responce_body)
    responce_body
  end

  private

  def search_params
    {keyid: ENV["GRUNAVI_ACCESS_TOKEN"], name: text}
  end
end