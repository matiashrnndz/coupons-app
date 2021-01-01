class RequestService
  attr_accessor :conn

  def initialize
    @conn = Faraday.new(url: ENV['API_URL'])
  end

  def get_request(verb, url, params, token=nil)
    response = conn.send(verb) do |req|
      req.url url, params
      req.headers['Authorization'] = token if token
    end
    if response.body != "PromoId does not exists."
      JSON.parse(response.body)
    else
      { errors: 'PromoId does not exists.' }
    end
  rescue Faraday::Error::ConnectionFailed => e
    { connection_error: true }
  end
end
