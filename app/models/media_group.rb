# This class represents "groupings" of media files. This is something
# of an abstract notion, since this project supports many different
# media types in the same format. One can think of a grouping as something
# like an album, or tv show. Single items (such as movies) also belong to
# a group, but are the only child of that group.
class MediaGroup < ApplicationRecord

  has_many :media_files, dependent: :destroy

  validates :name, presence: true
  validates :from_searcher, presence: true
  validates :searcher_key, presence: true

end
