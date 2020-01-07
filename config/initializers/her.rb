# config/initializers/her.rb
Her::API.setup url: "http://sac.tessi.com.br:3000" do |c|
    # Request
    c.use Faraday::Request::UrlEncoded
  
    # Response
    c.use Her::Middleware::DefaultParseJSON
  
    # Adapter
    c.use Faraday::Adapter::NetHttp
  end
