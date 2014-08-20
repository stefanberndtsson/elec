class ItemTag < ActiveRecord::Base
  belongs_to :item
  belongs_to :tag
  scope :item_ids_with_tag, ->(tag) { joins(:tag).where(tags: { name: tag.downcase }).select(:item_id) }
end
