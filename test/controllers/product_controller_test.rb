require 'test_helper'

class ProductControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get new_product_url
    assert_response :success
  end

  test 'should create product with uploaded images' do
    image = fixture_file_upload(Rails.root.join('test/fixtures/files/test_image.png'), 'image/png')

    assert_difference('Product.count', 1) do
      post products_url, params: {
        product: {
          name: 'Handmade Basket',
          description: 'Woven palm leaf basket',
          price: 1500,
          color: 'natural',
          images: [image]
        }
      }
    end

    product = Product.last
    assert_redirected_to product_url(product)
    assert_equal 1, product.images.count, 'Product images should be attached'
  end
end
