require 'helper'

class TestApplication < Test::Unit::TestCase
  include Rack::Test::Methods
  include XhrHelper

  def app
    Dagron::Application
  end

  test "index" do
    get '/'
    assert last_response.redirect?
    assert_equal "http://example.org/maps", last_response['location']
  end

  test "maps index" do
    map = stub('map', :id => 1, :name => "Foo")
    Dagron::Map.expects(:all).returns([map])
    get '/maps'
    assert last_response.ok?
  end

  test "create map" do
    map = mock('map', :valid? => true, :save => true, :id => 1)
    Dagron::Map.expects(:new).returns(map)
    map.expects(:set_only).with({'name' => 'foo'}, :name)
    post '/maps', 'map' => {'name' => 'foo'}
    assert last_response.redirect?
    assert_equal 'http://example.org/maps/1', last_response['location']
  end

  test "show map" do
    map = stub('map', :id => 1, :name => "Foo")
    Dagron::Map.expects(:[]).with(:id => "1").returns(map)
    map.expects(:images).returns([
      stub('image', :id => 1, :name => 'foo')
    ])
    get '/maps/1'
    assert last_response.ok?
  end

  test "update map" do
    map = mock('map', :id => 1, :valid? => true, :save => true)
    Dagron::Map.expects(:[]).with(:id => "1").returns(map)
    map.expects(:set_only).with({
      'viewport_x' => '123', 'viewport_y' => '123',
      'viewport_w' => '123', 'viewport_h' => '123'
    }, :viewport_x, :viewport_y, :viewport_w, :viewport_h)
    post '/maps/1', 'map' => {
      'viewport_x' => '123', 'viewport_y' => '123',
      'viewport_w' => '123', 'viewport_h' => '123'
    }
    assert last_response.redirect?
    assert_equal 'http://example.org/maps/1', last_response['location']
  end

  test "update map json" do
    map = stub('map', :id => 1, :valid? => true, :save => true)
    Dagron::Map.expects(:[]).with(:id => "1").returns(map)
    map.expects(:set_only).with({
      'viewport_x' => '123', 'viewport_y' => '123',
      'viewport_w' => '123', 'viewport_h' => '123'
    }, :viewport_x, :viewport_y, :viewport_w, :viewport_h)
    map.expects(:to_json).returns('"foo"')

    xhr '/maps/1', :as => :post, 'map' => {
      'viewport_x' => '123', 'viewport_y' => '123',
      'viewport_w' => '123', 'viewport_h' => '123'
    }
    assert last_response.ok?
    assert_equal 'application/json;charset=utf-8', last_response['content-type']
    assert_equal({'map' => "foo"}.to_json, last_response.body)
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

    post '/maps/1/images', :image => {
      :name => 'foo',
      :data => Rack::Test::UploadedFile.new(fixture_path('foo.png'), "image/png")
    }
    assert last_response.redirect?
    assert_equal 'http://example.org/maps/1', last_response['location']
  end

  test "show image" do
    map = stub('map', :id => 1, :name => "Foo")
    Dagron::Map.expects(:[]).with(:id => "1").returns(map)

    data = fixture_data('foo.png')
    image = mock('image', :data => data, :mime_type => 'image/png')
    map.expects(:images_dataset).returns(stub {
      expects(:[]).with(:id => "1").returns(image)
    })

    get '/maps/1/images/1'
    assert last_response.ok?
    assert_equal data, last_response.body
  end

  test "update image" do
    map = stub('map', :id => 1, :name => "Foo")
    Dagron::Map.expects(:[]).with(:id => "1").returns(map)

    image = mock('image', :valid? => true, :save => true)
    map.expects(:images_dataset).returns(stub {
      expects(:[]).with(:id => "1").returns(image)
    })
    image.expects(:set_only).with({'visible' => 'false', 'layer' => '5'}, :visible, :layer)

    post '/maps/1/images/1', 'image' => {'visible' => 'false', 'layer' => '5'}
    assert last_response.redirect?
    assert_equal 'http://example.org/maps/1', last_response['location']
  end

  test "update image json" do
    map = stub('map', :id => 1, :name => "Foo")
    Dagron::Map.expects(:[]).with(:id => "1").returns(map)

    image = mock('image', :valid? => true, :save => true)
    map.expects(:images_dataset).returns(stub {
      expects(:[]).with(:id => "1").returns(image)
    })
    image.expects(:set_only).with({'visible' => 'false', 'layer' => '5'}, :visible, :layer)
    image.expects(:to_json).returns('"foo"')

    xhr '/maps/1/images/1', :as => :post, 'image' => {'visible' => 'false', 'layer' => '5'}
    assert last_response.ok?
    assert_equal 'application/json;charset=utf-8', last_response['content-type']
    assert_equal({'image' => 'foo'}.to_json, last_response.body)
  end

  test "map presentation mode" do
    map = stub('map', {
      :id => 1,
      :viewport_x => 100, :viewport_y => 100,
      :viewport_w => 100, :viewport_h => 100,
    })
    Dagron::Map.expects(:[]).with(:id => "1").returns(map)
    image = stub('image', {
      :id => 1, :width => 123, :height => 123,
      :visible => true, :layer => 5
    })
    map.expects(:images).returns([image])

    get '/maps/1/presentation'
    assert last_response.ok?
  end

  test "map presentation json" do
    map = stub('map', :to_json => '"foo"')
    Dagron::Map.expects(:[]).with(:id => "1").returns(map)
    map.expects(:images_dataset).returns(mock(:to_json => '"bar"'))

    xhr '/maps/1/presentation'
    assert last_response.ok?
    assert_equal 'application/json;charset=utf-8', last_response['content-type']
    assert_equal '{"map":"foo","images":"bar"}', last_response.body
  end

  test "manage map" do
    map = stub('map', {
      :id => 1, :name => "Foo",
      :viewport_x => 100, :viewport_y => 100,
      :viewport_w => 100, :viewport_h => 100,
    })
    Dagron::Map.expects(:[]).with(:id => "1").returns(map)
    image = stub('image', {
      :id => 1, :name => 'foo',
      :height => 123, :width => 123,
      :visible => true, :layer => 5
    })
    map.expects(:images).returns([image])
    get '/maps/1/manage'
    assert last_response.ok?
  end

  test "delete map" do
    map = stub('map')
    Dagron::Map.expects(:[]).with(:id => "1").returns(map)
    map.expects(:destroy)
    post '/maps/1/delete'
    assert last_response.redirect?
    assert_equal "http://example.org/maps", last_response['location']
  end

  test "delete image" do
    map = stub('map', :id => 1)
    Dagron::Map.expects(:[]).with(:id => "1").returns(map)

    image = stub('image')
    map.expects(:images_dataset).returns(stub {
      expects(:[]).with(:id => "1").returns(image)
    })
    image.expects(:destroy)

    post '/maps/1/images/1/delete'
    assert last_response.redirect?
    assert_equal "http://example.org/maps/1", last_response['location']
  end
end
