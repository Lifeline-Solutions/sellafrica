class Product < ApplicationRecord
  has_many_attached :images
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  # validates :product_type, presence: true, inclusion: { in: PRODUCT_TYPE }

  # PRODUCT_TYPE = ['Fashion', 'Home & Living', 'Beauty', 'Electronics', 'Food & Pantry', 'Art & Craft'].freeze
end
