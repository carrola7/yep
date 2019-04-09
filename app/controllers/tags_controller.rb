class TagsController < BusinessesController
  def show
    @tag = Tag.find params[:id]
    @pagy, @businesses = pagy(@tag.businesses)
  end
end