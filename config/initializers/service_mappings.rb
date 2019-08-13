# This file contains the class list mappings for searchers, indexers, and downloaders.
# To add a new service to any of these three categories, simply write a class file in the
# appropriate folder, and add the class name to one of the below mappings. We use strings
# instead of classes so that changes made while the server is running are not lost.
# This method of mapping may change if a better alternative is presented (a config file?).

# Note: this file is only loaded once. The server should be restarted after any modifications.

SERVICE_MAPPINGS = {
    searchers: ['TmdbTv'].uniq.freeze,
    indexers: [].uniq.freeze,
    downloaders: [].uniq.freeze
}.freeze