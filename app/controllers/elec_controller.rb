class ElecController < ApplicationController
  def index
    name = params[:name]
    tags = params[:tags]
    search = params[:search]
    untagged = params[:untagged]
    @items = Item.all
    if search == "untagged"
      @items = @items.untagged
    elsif search[/^tags?:/]
      @items = @items.tagged_with_all(search[/^tags?:(.*)/,1].split(","))
    elsif search[/^name:/]
      @items = @items.named(search[/^name:(.*)/,1])
    elsif search && !search.blank?
      @items = @items.named(search) | @items.tagged_with_all(search.split(","))
    else
      @items = @items.untagged if untagged == "true"
      @items = @items.named(name) if name
      @items = @items.tagged_with_all(tags.split(",")) if tags
    end
    render json: @items
  end

  def show
    @item = Item.find(params[:id])
    render json: @item
  end
  
  def get_file
    @item = Item.find(params[:id])
    file = @item.file
    send_file file.full_path, type: file.file_type, filename: file.filename, disposition: :inline
  end
end
