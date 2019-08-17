# Searcher for Google Books API
class GoogleBooks

  # Required
  def self.description
    'A searcher for the Google Books API'
  end

  # Required
  def self.search(query, start, max)

    connection = setup_connection('volumes')
    connection.params[:q] = query

    response = connection.get
    response = JSON.parse(response.body)['items']

    responses = response.map do |r|
      to_search_result(r)
    end

    return responses

  end

  # Required
  def self.find(key)

  end

  # Helper methods

  def self.setup_connection(endpoint)

    return Faraday::Connection.new("https://www.googleapis.com/books/v1/#{endpoint}") do |c|
      c.adapter(Faraday.default_adapter)
      c.headers['Content-Type'] = 'application/json;charset=utf-8'
    end

  end

  def self.to_search_result(api_response)

    return SearchResult.new(
      key: api_response['id'],
      name: api_response.dig('volumeInfo', 'title'),
      description: api_response.dig('volumeInfo', 'description'),
      poster_url: api_response.dig('volumeInfo', 'imageLinks', 'smallThumbnail')
    )

  end

end