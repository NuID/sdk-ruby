require "httparty"

module NuID::SDK::API
  class Auth
    include HTTParty
    # format :json
    base_uri "https://auth.nuid.io"

    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key
      self.class.headers({
        "X-API-Key" => @api_key,
        "Accept"    => "application/json"
      })
    end

    def challenge_get(credential)
      _post("/challenge", {"nuid/credential" => credential})
    end

    def challenge_verify(challenge_jwt, proof)
      _post("/challenge/verify", {
        "nuid.credential.challenge/jwt" => challenge_jwt,
        "nuid.credential/proof"         => proof
      })
    end

    def credential_create(verified_credential)
      _post("/credential", {"nuid.credential/verified" => verified_credential})
    end

    def credential_get(nuid)
      self.class.get("/credential/#{nuid}")
    end

    private

    def _post(path, body)
      self.class.post(path, {
        headers: {"Content-Type" => "application/json"},
        body: body
      })
    end
    
  end
end
