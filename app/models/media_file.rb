# This class represents a single media item. When all stages of
# processing have completed, it should point to an imported file
# on-disk. No media files should exist outside of a media group.
class MediaFile < ApplicationRecord

  belongs_to :media_group

  serialize :search_data, JSON

  validates :name, presence: true

  # Exclude private fields from JSON response
  # Avoids a bug in overriding as_json
  def serializable_hash(*)

    excludes = ['id', 'media_group_id', 'created_at', 'updated_at', 'file_path', 'extra_data']
    output = super.except(*excludes)
    output.merge!(search_data) if search_data

    # Flatten the extra data fields into output
    return output

  end

end
