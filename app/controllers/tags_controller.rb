class TagsController < BusinessesController
  def show
    @tag = Tag.find_by slug: params[:slug]
    @pagy, @businesses = pagy(@tag.businesses)
  end
end
