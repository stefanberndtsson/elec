class ElecController < ApplicationController
  def index
    name = params[:name]
    tags = params[:tags]
    untagged = params[:untagged]
    @items = Item.all
    @items = @items.untagged if untagged == "true"
    @items = @items.named(name) if name
    @items = @items.tagged_with_all(tags.split(",")) if tags
    render json: @items
  end

  def show
    @item = Item.find(params[:id])
    render json: @item
  end
end
