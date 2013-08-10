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
    map = mock('map', :valid? => true, :save => true)
    Dagron::Map.expects(:new).with(:name => 'foo').returns(map)
    post '/maps', :name => 'foo'
    assert last_response.redirect?
    assert_equal 'http://example.org/maps', last_response['location']
  end

  test "map" do
    map = stub('map', :id => 1, :name => "Foo")
    Dagron::Map.expects(:[]).with(:id => "1").returns(map)
    get '/maps/1'
    assert last_response.ok?
  end

  test "create image" do
    map = stub('map', :id => 1, :name => "Foo")
    Dagron::Map.expects(:[]).with(:id => "1").returns(map)

    image = mock('image', :valid? => true, :save => true)
    Dagron::Image.expects(:new).with({
      :name => 'foo',
      :filename => 'foo.png',
      :data => fixture_data('foo.png'),
      :map_id => 1
    }).returns(image)

    post '/maps/1/images', {
      :name => 'foo',
      :data => Rack::Test::UploadedFile.new(fixture_path('foo.png'), "image/png")
    }
    assert last_response.redirect?
    assert_equal 'http://example.org/maps/1', last_response['location']
  end
end
