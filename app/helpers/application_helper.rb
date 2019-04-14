module ApplicationHelper
  include Pagy::Frontend

  def display_price(num)
    Array.new(num).map { '&#8364; ' }.join.html_safe
  end

  def print_stars(num)
    ('&#9733; ' * num).html_safe
  end

  def print_euros(num)
    ('&#8364; ' * num).html_safe
  end
end
