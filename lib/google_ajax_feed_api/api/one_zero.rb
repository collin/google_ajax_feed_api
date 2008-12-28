module Google
  module Ajax
    class Feed
      module API
        class OneZero
          class << self
            # The endpoint URI for lookup requests
            def lookup
              "http://ajax.googleapis.com/ajax/services/feed/lookup"
            end
            
            # The endpoint URI for search requests
            def find
              "http://ajax.googleapis.com/ajax/services/feed/find"
            end
            
            # The endpoint URI for loading feeds
            def load 
              "http://ajax.googleapis.com/ajax/services/feed/load"
            end
            
            # Builds a query to lookup a feed for a url
            def lookup_query url
              "#{lookup}#{params url}"
            end
            
            # Builds a query to search for feeds
            # query is a search term
            def find_query query
              "#{find}#{params query}"
            end
            
            # Builds a query
            # options are overrides for Feed#config options
            def load_query url, options={}
              "#{load}#{params url}#{load_params options}"
            end
            
            def load_params options={} #:nodoc
              options = ({
                :limit => Feed.config.limit,
                :history => Feed.config.history
              }).merge(options)
              
              params = "&num=#{options[:limit]}"
              params << '&scoring=h' if options[:history]
              params        
            end
            
            def params query #:nodoc:
              "?v=1.0&q=#{URI.encode query}"
            end
          end
        end
      end
    end
  end
end
