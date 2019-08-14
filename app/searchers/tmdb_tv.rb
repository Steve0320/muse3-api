# Searcher for The Movie DB API (specifically for TV shows)
class TmdbTv

  extend SearchHelper

  # Helpful constants
  BASE_URL = 'https://api.themoviedb.org'.freeze
  API_KEY = '7487a1aeaf17758c1b3f2d52f0c5d813'.freeze
  API_VERSION = 3
  RESULTS_PER_PAGE = 20
  POSTER_RESOLUTION = 'w185'.freeze

  # Return an array of results adhering to the SearchResult model. In debug mode, this array
  # will be validated by the searches controller. In normal mode, this will be skipped for
  # performance reasons. This method may throw an ExternalServiceError if the API cannot
  # be reached.
  def self.search(query, start, max)

    # Define connection to API
    connection = setup_connection('search/tv')
    connection.params[:query] = query

    # Calculate necessary ranges
    pages = page_range(start, max, RESULTS_PER_PAGE)
    results = results_range(start, max, RESULTS_PER_PAGE)

    # Load each needed page
    # TODO: implement some caching to eliminate duplicate requests
    responses = pages.each_with_object([]) do |page, c|

      # Get required page
      response = connection.get do |conn|
        conn.params[:page] = page
      end

      # TODO: throw an exception if the request fails
      raise 'Error: status was not 200' unless response.status == 200

      # TODO: break early if we run out of results
      c.concat(JSON.parse(response.body)['results'])

    end

    # Pack into correct form
    sanitized_responses = responses[results].map do |r|
      to_search_result(r)
    end

    # Return chunk of array requested
    return sanitized_responses

  end

  # Return the full structure of MediaGroup->MediaFile for the given key
  def self.find(key)

    # Get the initial information
    connection = setup_connection("tv/#{key}")
    response = connection.get

    # Extract the list of season numbers
    season_list = JSON.parse(response.body)['seasons']
    appends = season_list.map { |s| "season/#{s['season_number']}" }.join(',')

    # Get full list with episode information
    # TODO: Test with > 20 seasons (will probably have to do batches)
    response = connection.get do |c|
      c.params[:append_to_response] = appends
    end

    return to_media_structure(JSON.parse(response.body))

  end

  # Helper methods

  # Create a new API connection
  def self.setup_connection(endpoint)

    return Faraday::Connection.new("#{BASE_URL}/#{API_VERSION}/#{endpoint}") do |c|
      c.adapter(Faraday.default_adapter)
      c.params = { api_key: API_KEY }
      c.headers['Content-Type'] = 'application/json;charset=utf-8'
    end

  end

  # Parse file name into a poster URL
  def self.poster_path(file_name)
    "https://image.tmdb.org/t/p/#{POSTER_RESOLUTION}/#{file_name}"
  end

  # Pack API data into full media structure, assuming appends format
  def self.to_media_structure(api_response)

    # Create root MediaGroup
    root_group = MediaGroup.new(
      name: api_response['name'],
      description: api_response['overview'],
      poster_url: poster_path(api_response['poster_path'])
    )

    # Merge all episode lists into a flat array
    seasons = api_response.select { |k, _v| k.include?('season/') }
    episodes = seasons.flat_map { |_k, v| v['episodes'] }

    # Create MediaFiles from episodes
    episodes.each do |e|

      file = MediaFile.new(
        name: e['name'],
        extra_data: {
            season: e['season_number'],
            episode: e['episode_number'],
            overview: e['overview']
        }
      )

      # Assign to relation without saving
      root_group.association(:media_files).add_to_target(file)

    end

    return root_group

  end

  # Pack a raw API data into the appropriate structure
  def self.to_search_result(api_response)

    poster_url = if api_response['poster_path']
                   poster_path(api_response['poster_path'])
                 end

    rating = (api_response['vote_average'] * 10).round(half: :up)

    return SearchResult.new(
      key: api_response['id'],
      name: api_response['name'],
      description: api_response['overview'],
      poster_url: poster_url,
      rating: rating
    )

  end

end