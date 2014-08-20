class Item < ActiveRecord::Base
  has_many :item_tags
  has_many :tags, :through => :item_tags
  has_many :item_datafiles
  has_many :datafiles, :through => :item_datafiles
  scope :untagged, -> { includes(:item_tags).where(item_tags: {item_id: nil}) }
  scope :named, ->(n) { where("lower(name) LIKE ?", "%#{n}%") } 
  validates_presence_of :name
  validates_presence_of :checksum
  validates_length_of :checksum, maximum: 40, minimum: 40
  validates_format_of :checksum, :with => /\A[0-9a-f]*\z/
  
  def self.tagged_with_all(tags)
    items = Item.all
    tags.each do |tag|
      items = items.where(id: ItemTag.item_ids_with_tag(tag.strip))
    end
    items
  end
  
  def add_tag(tag)
    tag = Tag.find_or_create_by(name: tag.strip.downcase)
    return nil if tags.include?(tag)
    self.item_tags.create(tag_id: tag.id)
  end
  
  def as_json(options = {})
    super.merge(
    {
      tags: tags.pluck(:name),
      files: datafiles
    }
    )
  end
end
