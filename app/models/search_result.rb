# This model defines the form that a search result from one of the
# searcher classes should conform to. The validations should only
# be checked in debug mode for speed. Front-end code can expect
# responses from the /search endpoint to adhere to this model.
class SearchResult

  include ActiveModel::Model

  # Define model fields
  attr_accessor :key, :name, :original_name, :description, :poster_url, :rating

  # Required fields
  validates :key, presence: true
  validates :name, presence: true

end