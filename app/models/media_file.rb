# This class represents a single media item. When all stages of
# processing have completed, it should point to an imported file
# on-disk. No media files should exist outside of a media group.
class MediaFile < ApplicationRecord

  belongs_to :media_group

  serialize :extra_data, JSON

  validates :name, presence: true

end
