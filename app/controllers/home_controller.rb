class HomeController < ApplicationController
  def index
    assertion = request.env["HTTP_X_GOOG_IAP_JWT_ASSERTION"]
    @email, @user_id = validate_assertion(assertion)
  end

  private

  def certificates
    uri = URI.parse "https://www.gstatic.com/iap/verify/public_key"
    response = Net::HTTP.get_response uri
    JSON.parse response.body
  end

  def validate_assertion(assertion)
    a_header = Base64.decode64 assertion.split(".")[0]
    key_id = JSON.parse(a_header)["kid"]
    cert = OpenSSL::PKey::EC.new certificates[key_id]
    info = JWT.decode assertion, cert, true, algorithm: "ES256", audience: ENV['JWT_AUD']
    return info[0]["email"], info[0]["sub"]

  rescue StandardError => e
    [nil, nil]
  end
end
