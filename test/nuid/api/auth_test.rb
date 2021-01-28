require "test_helper"
require "nuid/sdk/api/auth"

class NuID::SDK::API::AuthTest < Minitest::Test
  def setup
    @api = ::NuID::SDK::API::Auth.new("my-api-key")
  end

  def test_credential_create
    res = @api.credential_create({ verified: true, bogus: :obviously })
    assert(res.code == 500)
  end
end
