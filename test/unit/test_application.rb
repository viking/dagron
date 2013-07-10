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
  end

  test "maps index" do
    map = stub('map', :id => 1, :name => "Foo")
    Dagron::Map.expects(:all).returns([map])
    get '/maps'
    assert last_response.ok?
  end

  test "create map" do
    file = Tempfile.new('dagron')
    file.puts("<map></map>")
    file.flush
    file.rewind
    begin
      map = mock('map', :valid? => true, :save => true)
      Dagron::Map.expects(:new).with({
        :name => 'foo',
        :filename => File.basename(file.path),
        :data => "<map></map>\n"
      }).returns(map)
      post '/maps', {
        :name => 'foo',
        :data => Rack::Test::UploadedFile.new(file, "text/xml")
      }
      assert last_response.redirect?
      assert_equal 'http://example.org/maps', last_response['location']
    ensure
      file.unlink
    end
  end
end
