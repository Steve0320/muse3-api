# This file contains the name->service mappings for searchers, indexers, and downloaders.
# To add a new service to any of these three categories, simply write a class file in the
# appropriate folder, and add the class to one of the below mappings.

# Note: this file is only loaded once. The server should be restarted after any modifications.

SERVICE_MAPPINGS = {

    searchers: {
        'tmdb_tv' => TmdbTv,
        'test' => TmdbTv
    },

    indexers: {

    },

    downloaders: {

    }

}.freeze