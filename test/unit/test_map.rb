require 'helper'

class TestMap < Test::Unit::TestCase
  def new_map(attribs = {})
    Dagron::Map.new({
      :name => 'foo',
      :filename => "foo.tmx",
      :data => '<map></map>'
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

  test "requires filename" do
    map = new_map(:filename => nil)
    assert !map.valid?
  end

  test "requires data" do
    map = new_map(:data => nil)
    assert !map.valid?
  end
end
