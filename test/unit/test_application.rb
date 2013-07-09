require 'helper'

class TestApplication < Test::Unit::TestCase
  include Rack::Test::Methods
  include XhrHelper

  def app
    Dagron::Application
  end

  test "index" do
    get '/'
    assert last_response.ok?
    assert_match "sup?", last_response.body
  end
end
