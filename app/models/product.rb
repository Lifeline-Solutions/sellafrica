class Product < ApplicationRecord
  has_many_attached :images

  attribute :stock, :integer, default: 10
  attribute :active, :boolean, default: true

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :category, inclusion: { in: ->(_) { CATEGORIES.keys } }, allow_blank: true

  CATEGORIES = {
    'fashion' => 'Fashion',
    'home-living' => 'Home & Living',
    'beauty' => 'Beauty',
    'electronics' => 'Electronics',
    'food-pantry' => 'Food & Pantry',
    'art-crafts' => 'Art & Crafts'
  }.freeze

  SORTS = {
    'newest' => 'Newest',
    'price_asc' => 'Price: Low to high',
    'price_desc' => 'Price: High to low',
    'name_asc' => 'Name: A to Z'
  }.freeze

  def category_name
    CATEGORIES[category]
  end

  def new_arrival?
    created_at.present? && created_at >= 14.days.ago
  end

  def colors
    color.to_s.split(',').map(&:strip).reject(&:blank?)
  end

  def price_cents
    (price.to_f * 100).to_i
  end

  def currency
    'KSh'
  end

  ShopInfo = Struct.new(:business_name)

  def shop
    ShopInfo.new('SellAfrica Artisan')
  end
end
