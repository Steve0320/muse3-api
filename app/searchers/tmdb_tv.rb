# Searcher for The Movie DB API (specifically for TV shows)
class TmdbTv

  include SearchHelper

  BASE_URL = 'https://api.themoviedb.org'.freeze
  API_KEY = '7487a1aeaf17758c1b3f2d52f0c5d813'.freeze
  API_VERSION = 3

  # Required: the unique value to prefix onto keys from this searcher
  KEY_PREFIX = 'tmdbtv'.freeze

  # Return the "nice" search results with unique key. This key only needs to be unique within
  # the context of this searcher. The searches controller will append the KEY_PREFIX onto results
  # from this searcher, and strip it back off before passing it to the list_media function.
  def self.search(query)

    connection = Faraday::Connection.new(BASE_URL) do |c|
      c.adapter Faraday.default_adapter
      c.params = { api_key: API_KEY }
      c.headers['Content-Type'] = 'application/json;charset=utf-8'
    end

    response = connection.get("#{API_VERSION}/search/tv") do |q|
      q.params[:query] = query
    end

    return JSON.parse(response.body)

  end

  # Return the full list of media based on search key as described earlier
  def self.list_media(key)

  end

end