module Api::V1

  class SearchesController < ApplicationController

    # Register the available Searcher classes
    SEARCHER_CLASSES = [TmdbTv, GoogleBooks].freeze

    before_action :set_query, only: :search
    before_action :set_key, only: :search_by_key
    before_action :set_pagination_params, only: :search

    # GET /api/v1/search
    def search

      # Parse the processors list and lookup classes
      processor_classes = if params[:p]
                            targets = params[:p].split(',')
                            SEARCHER_CLASSES.find_all { |s| targets.include?(s.name) }
                          else
                            SEARCHER_CLASSES
                          end

      # Map output of each searcher by searcher name
      output = processor_classes.each_with_object({}) do |klass, c|

        begin

          results = klass.search(@query, @start, @max).map do |r|
            r.key = "#{klass.name}$#{r.key}"
            # TODO: check validation of r
            r
          end

          c[klass.name] = results

        rescue StandardError => e
          c[klass.name] = { error: e }
        end

      end

      render json: { results: output }

    end

    # GET /api/v1/search/by_key
    def search_by_key

      # Split off searcher name from key
      klass_name, key = @key.split('$', 2)

      # Guard against invalid keys
      # TODO: these should throw exceptions

      unless key.present?
        render json: { error: 'keys missing bruh' }
        return
      end

      # Match the class name to a searcher
      search_klass = SEARCHER_CLASSES.find { |s| s.name == klass_name }

      if search_klass.nil?
        render json: { error: 'key refers to invalid searcher bro' }
        return
      end

      begin
        result = search_klass.find(key)
      rescue StandardError => e
        result = { error: e }
      end

      # TODO: override to_json in MediaFile and MediaGroup to exclude id, etc.
      render json: { result: result }, include: :media_files

    end

    # GET /api/v1/search/processors
    def list_processors

      output = SEARCHER_CLASSES.map do |s|
        {
            name: s.name,
            description: s.description
        }
      end

      render json: { searchers: output }

    end

    private

    def set_query
      @query = params.require(:q)
    end

    def set_key
      @key = params.require(:k)
    end

    # Set params or default if invalid
    def set_pagination_params

      max = params[:max].to_i
      start = params[:start].to_i

      @max = max.positive? ? max : 20
      @start = start.positive? ? start : 0

    end

  end

end
