module Api::V1

  class SearchesController < ApplicationController

    before_action :set_searchers
    before_action :set_query, only: :search
    before_action :set_key, only: :search_by_key
    before_action :set_pagination_params, only: :search

    # GET /api/v1/search
    def search

      # Parse the processors list and lookup classes
      processor_classes = if params[:p]
                            @searchers & params[:p].split(',')
                          else
                            @searchers
                          end

      # Map output of each searcher by searcher name
      output = processor_classes.each_with_object({}) do |klass_name, c|

        klass = klass_name.constantize

        results = klass.search(@query, @start, @max).map do |r|
          r.key = "#{klass_name}$#{r.key}"
          # TODO: check validation of r
          r
        end

        c[klass_name] = results

      end

      render json: { results: output }

    end

    # GET /api/v1/search/by_key
    def search_by_key

      # Split off searcher name from key
      klass_name, key = @key.split('$', 2)

      # Guard against invalid keys
      # TODO: these should throw exceptions

      unless @searchers.include?(klass_name)
        render json: { error: 'key refers to invalid searcher bro' }
        return
      end

      unless key.present?
        render json: { error: 'keys missing bruh' }
        return
      end

      # Search the searcher for the key
      klass = klass_name.constantize
      result = klass.find(key)

      # TODO: override to_json in MediaFile and MediaGroup to exclude id, etc.
      render json: { result: result }, include: :media_files

    end

    # GET /api/v1/search/processors
    def list_processors
      render json: { searchers: @searchers }
    end

    private

    def set_query
      @query = params.require(:q)
    end

    def set_key
      @key = params.require(:k)
    end

    def set_searchers
      @searchers = SERVICE_MAPPINGS[:searchers]
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
