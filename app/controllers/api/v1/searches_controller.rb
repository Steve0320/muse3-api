module Api::V1

  class SearchesController < ApplicationController

    before_action :set_searchers
    before_action :set_query, only: :search

    rescue_from ActionController::ParameterMissing, with: :missing_param

    # GET /api/v1/search
    def search

      # Parse the processors list and lookup classes
      processor_classes = if params[:p]
                            requested = params[:p].split(',')
                            @searchers.slice(*requested)
                          else
                            @searchers
                          end

      # Map the output of each search class into a hash
      output = processor_classes.uniq.each_with_object({}) do |(name, klass), c|
        c[name] = klass.search(@query)
      end

      render json: { results: output }

    end

    # GET /api/v1/search/processors
    def list_processors
      render json: { searchers: @searchers.keys }
    end

    private

    def missing_param
      render json: { you_dun_fuked_up: 'You messed it up' }
    end

    def set_query
      @query = params.require(:q)
    end

    def set_searchers
      @searchers = SERVICE_MAPPINGS[:searchers]
    end

  end

end
