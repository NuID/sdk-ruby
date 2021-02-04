require "test_helper"
require "nuid/sdk/api/auth"

class NuID::SDK::API::AuthTest < Minitest::Test
  attr_accessor :secret

  def setup
    raise "Env param 'NUID_API_KEY' missing! Can't run tests without it!" unless ENV['NUID_API_KEY']
    @api = ::NuID::SDK::API::Auth.new(ENV['NUID_API_KEY'])
    @secret = 'pass#123'
  end

  def test_roundtrip
    # Credential Create
    verified = zk('verifiableFromSecret', @secret)
    res = @api.credential_create(verified)
    assert_equal(201, res.code)
    nuid = res.parsed_response['nu/id']
    credential = res.parsed_response['nuid/credential']

    # Credential Get
    res = @api.credential_get(nuid)
    assert_equal(200, res.code)
    refute_nil(res.parsed_response)

    # Challenge Get
    res = @api.challenge_get(credential)
    assert_equal(201, res.code)
    challenge_jwt = res.parsed_response['nuid.credential.challenge/jwt']
    refute_nil(challenge_jwt)

    # Challenge Verify
    challenge = claims(challenge_jwt)
    proof = zk('proofFromSecretAndChallenge', @secret, challenge)
    res = @api.challenge_verify(challenge_jwt, proof)
    assert_equal(200, res.code)
  end

  private

  def claims(jwt)
    JSON.parse(Base64.decode64(jwt.split('.')[1]))
  end

  def zk(command, *args)
    cmd = "nuid-pg #{command} '#{args.to_json}'"
    res = %x{#{cmd}}
    if $? == 0
      JSON.parse(res)
    else
      raise "Command failed!\n  #{cmd}\n  #{res}"
    end
  end
end
