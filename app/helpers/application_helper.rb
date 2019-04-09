module ApplicationHelper
  include Pagy::Frontend
  
  def display_price(num)
    Array.new(num).map { |char| "&#8364; "}.join.html_safe
  end

  def print_stars(n)
    ("&#9733; " * n).html_safe
  end

  def print_euros(n)
    ("&#8364; " * n).html_safe
  end
end
