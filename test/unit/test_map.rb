require 'helper'

class TestMap < Test::Unit::TestCase
  def new_map(attribs = {})
    Dagron::Map.new({
      :name => 'foo'
    }.merge(attribs))
  end

  test "requires name" do
    map = new_map(:name => nil)
    assert !map.valid?
  end

  test "requires unique name" do
    map_1 = new_map(:name => 'Foo')
    map_1.save
    map_2 = new_map(:name => 'Foo')
    assert !map_2.valid?
  end

  test "deletes images on destroy" do
    map = new_map
    map.save
    image = Dagron::Image.new({
      :name => 'foo', :filename => 'foo.png',
      :data => fixture_data('foo.png'), :map_id => map.id
    })
    image.save
    map.destroy
    assert_nil Dagron::Image[:id => image.id]
  end
end
