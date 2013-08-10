require 'helper'

class TestImage < Test::Unit::TestCase
  def new_image(attribs = {})
    Dagron::Image.new({
      :name => 'foo',
      :filename => 'foo.png',
      :data => fixture_data('foo.png'),
      :map_id => 1
    }.merge(attribs))
  end

  test "requires name" do
    image = new_image(:name => nil)
    assert !image.valid?
  end

  test "requires unique name" do
    image_1 = new_image(:name => 'Foo')
    image_1.save
    image_2 = new_image(:name => 'Foo')
    assert !image_2.valid?
  end

  test "requires filename" do
    image = new_image(:filename => nil)
    assert !image.valid?
  end

  test "requires data" do
    image = new_image(:data => nil)
    assert !image.valid?
  end

  test "requires map_id" do
    image = new_image(:map_id => nil)
    assert !image.valid?
  end
end
