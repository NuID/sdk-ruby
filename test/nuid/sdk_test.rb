require "test_helper"

class NuID::SDKTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::NuID::SDK::VERSION
  end
end
