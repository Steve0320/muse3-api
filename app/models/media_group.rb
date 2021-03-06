# This class represents "groupings" of media files. This is something
# of an abstract notion, since this project supports many different
# media types in the same format. One can think of a grouping as something
# like an album, or tv show. Single items (such as movies) also belong to
# a group, but are the only child of that group.
class MediaGroup < ApplicationRecord

  has_many :media_files, dependent: :destroy

  # Store data that doesn't match up with the normal global fields.
  # This should always be a string->string hash as types are not preserved
  serialize :search_data, JSON

  validates :name, presence: true
  validates :searcher_key, presence: true
  # TODO: make sure this string is in the searchers array
  validates :from_searcher, presence: true

  # Exclude private fields from JSON response
  # Avoids a bug in overriding as_json
  def serializable_hash(*)

    excludes = ['id', 'created_at', 'updated_at', 'from_searcher', 'searcher_key']
    output = super.except(*excludes)
    output.merge!(search_data) if search_data

    # Flatten the extra data fields into output
    return output

  end

end
