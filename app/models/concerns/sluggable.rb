module Sluggable
  def to_param
    self.slug
  end

  def generate_slug
    self.slug = self.created_at.to_datetime.strftime('%Y%m%d%H%M%S%L').to_i.to_s(32)
    self.save
  end
end