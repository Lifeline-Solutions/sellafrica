require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test 'validates category inclusion when present' do
    product = Product.new(name: 'Test', description: 'Desc', price: 100, category: 'invalid-category')
    assert_not product.valid?
    assert_includes product.errors[:category], 'is not included in the list'

    product.category = 'fashion'
    assert product.valid?
    assert_equal 'Fashion', product.category_name
  end
end
