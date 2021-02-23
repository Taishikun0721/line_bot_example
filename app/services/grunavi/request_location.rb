class Grunavi::RequestLocation

  attr_reader :latitude, :longitude
  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
  end

  def send
    uri = URI.parse(Settings.grunavi_end_point[:url] + '?' + URI.encode_www_form(search_params))
    string_responce_body = Net::HTTP.get_response(uri).body
    responce_body = JSON.parse(string_responce_body)
    responce_body
  end

  private

  def search_params
    { keyid: ENV["GRUNAVI_ACCESS_TOKEN"], latitude: latitude, longitude: longitude, range: Settings.grunavi_params[:range_flag], takeout: Settings.grunavi_params[:takeout_flag] }
  end

end