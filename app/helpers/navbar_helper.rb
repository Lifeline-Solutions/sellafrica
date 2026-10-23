# Small helpers so the navbar partial stays clean and works whether or not
# Devise / a cart model are wired up yet. Swap the fallbacks for your real code.
module NavbarHelper
  def navbar_categories
    [
      { name: 'Fashion', slug: 'fashion' },
      { name: 'Home & Living', slug: 'home-living' },
      { name: 'Beauty', slug: 'beauty' },
      { name: 'Electronics', slug: 'electronics' },
      { name: 'Food & Pantry', slug: 'food-pantry' },
      { name: 'Art & Crafts', slug: 'art-crafts' }
    ]
    # Later: Category.where(featured: true).order(:position).map { |c| { name: c.name, slug: c.slug } }
  end

  def navbar_signed_in?
    respond_to?(:user_signed_in?) ? user_signed_in? : false
  end

  def navbar_user_first_name
    user = respond_to?(:current_user) ? current_user : nil
    user&.try(:first_name).presence || user&.email.to_s.split('@').first
  end

  def navbar_cart_count
    return @cart_count if defined?(@cart_count) && @cart_count

    cart = respond_to?(:current_cart) ? current_cart : nil
    cart&.try(:items_count).to_i
  end

  def navbar_cart_path
    respond_to?(:cart_path) ? cart_path : '#'
  end

  def navbar_sign_in_path
    respond_to?(:new_user_session_path) ? new_user_session_path : '#'
  end

  def navbar_sign_up_path
    respond_to?(:new_user_registration_path) ? new_user_registration_path : '#'
  end

  def navbar_sign_out_path
    respond_to?(:destroy_user_session_path) ? destroy_user_session_path : '#'
  end

  def new_seller_path_or_fallback
    respond_to?(:new_seller_path) ? new_seller_path : '#'
  end
end
