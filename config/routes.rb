Rails.application.routes.draw do

  namespace :api do

    namespace :v1 do

      # GET /search?q=...&p=... gets search results from the given query q. Optional p specifies processors
      get '/search', to: 'searches#search'

      # GET /search/processors gets the list of available values for p
      get '/search/processors', to: 'searches#list_processors'

    end

  end

end
