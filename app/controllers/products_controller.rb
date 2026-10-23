class ProductsController < ApplicationController
  def index
    @category = params[:category].presence
    @query = params[:q].presence
    @sort = params[:sort].presence || 'newest'

    scope = Product.all

    if @category.present? && Product::CATEGORIES.key?(@category)
      if Product.column_names.include?('category')
        scope = scope.where(category: @category)
      elsif Product.column_names.include?('product_type')
        scope = scope.where(product_type: @category)
      end
    end

    scope = scope.where('name ILIKE :q OR description ILIKE :q', q: "%#{@query}%") if @query.present?

    scope = case @sort
            when 'price_asc'
              scope.order(Arel.sql('CAST(price AS numeric) ASC'))
            when 'price_desc'
              scope.order(Arel.sql('CAST(price AS numeric) DESC'))
            when 'name_asc'
              scope.order(name: :asc)
            else
              scope.order(created_at: :desc)
            end

    @total = scope.count
    @page = [params[:page].to_i, 1].max
    per_page = 12
    @products = scope.offset((@page - 1) * per_page).limit(per_page)
    @prev_page = @page > 1 ? @page - 1 : nil
    @next_page = @total > @page * per_page ? @page + 1 : nil
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def show
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])

    @product.images.where(id: params[:remove_image_ids]).each(&:purge) if params[:remove_image_ids].present?

    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully deleted.'
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :color, :category, :product_type, :stock, :active, images: [])
  end
end
