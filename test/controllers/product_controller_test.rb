require 'test_helper'

class ProductControllerTest < ActionDispatch::IntegrationTest
  def setup
    FileUtils.mkdir_p(Rails.root.join('test/fixtures/files'))
    @image_path = Rails.root.join('test/fixtures/files/test_image.png')
    # Base64 1x1 png
    png_data = Base64.decode64('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==')
    File.binwrite(@image_path, png_data)
  end

  test 'should get index' do
    get products_url
    assert_response :success
  end

  test 'should get index with category and sort' do
    get products_url(category: 'fashion', sort: 'price_asc')
    assert_response :success
  end

  test 'should get new' do
    get new_product_url
    assert_response :success
    assert_select 'select[name="product[category]"]' do
      assert_select 'option[value="fashion"]', text: 'Fashion'
      assert_select 'option[value="home-living"]', text: 'Home & Living'
    end
  end

  test 'should get edit' do
    product = products(:one)
    get edit_product_url(product)
    assert_response :success
    assert_select 'select[name="product[category]"]'
  end

  test 'should create product with category and uploaded images' do
    image = fixture_file_upload(@image_path, 'image/png')

    assert_difference('Product.count', 1) do
      post products_url, params: {
        product: {
          name: 'Handmade Basket',
          description: 'Woven palm leaf basket',
          price: 1500,
          color: 'natural',
          category: 'fashion',
          images: [image]
        }
      }
    end

    product = Product.find_by(name: 'Handmade Basket')
    assert_redirected_to product_url(product)
    assert_equal 1, product.images.count, 'Product images should be attached'
    assert_equal 'Handmade Basket', product.name
    assert_equal 'fashion', product.category
  end

  test 'should show product' do
    product = products(:one)
    image = fixture_file_upload(@image_path, 'image/png')
    product.images.attach(image)

    get product_url(product)
    assert_response :success
    assert_select 'h1', text: /Product One/
  end

  test 'should update product and remove images if requested' do
    product = products(:one)
    image = fixture_file_upload(@image_path, 'image/png')
    product.images.attach(image)
    attached_image = product.images.first

    patch product_url(product), params: {
      product: {
        name: 'Updated Basket',
        description: 'Updated description',
        price: 1800,
        category: 'home-living'
      },
      remove_image_ids: [attached_image.id]
    }

    assert_redirected_to product_url(product)
    product.reload
    assert_equal 'Updated Basket', product.name
    assert_equal 'home-living', product.category
    assert_equal 0, product.images.count
  end
end
