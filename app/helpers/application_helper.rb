module ApplicationHelper
  def display_price(num)
    Array.new(num).map { |char| "&#8364; "}.join.html_safe
  end

  def print_stars(n)
    ("&#9733; " * n).html_safe
  end
end
