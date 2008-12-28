require 'rubygems'
require 'ostruct'
require 'extlib'
require 'json/pure'
require 'uri'
require 'open-uri'

module Google #:nodoc:
  module Ajax #:nodoc:
    class Feed
# = Google Ajax Feed Api
      class Entry        
        def inspect # :nodoc:
          "<#Google::Ajax::Feed::Entry link=#{link} title=#{title}>"
        end 
        
        # The permalink for this entry
        def link
          @data["link"]
        end
        
        # The title for this entry
        def title
          @data["title"]
        end

        # The content of this entry
        def content
          @data["content"]
        end        

        # A snippet of this entries content
        def snippet
          @data["contentSnippet"]
        end        

        # The author for this specific entry
        def author
          @data["author"]
        end        

        # The publication date for this entry
        def created_at
          @data["publishedDate"]
        end        

        private
        def initialize data #:nodoc:
          @data = data
        end
      end
    
      module API #:nodoc:
        def self.[] version
          case version
          when '1.0'
            OneZero
          end
        end
        
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
            
            private
            def load_params options={} #:nodoc
              options = ({
                :limit => Feed.config.limit,
                :history => Feed.config.history
              }).merge(options)
              
              params = "&num=#{options[:limit]}"
              params << '&scoring=h' if options[:history]
              params        
            end
            
            private
            def params query #:nodoc:
              "?v=1.0&q=#{URI.encode query}"
            end
          end
        end
      end

      class << self     
        # Default values are:
        # * config.version = '1.0'
        #
        # version specifies what version of the feed API to use.
        # 1.0 is the only version that exists and thusly the only
        # option supported. DO NOT CHANGE THIS
        #
        # * config.limit   = 15
        #
        # limit specifies how many feed items may be fetched at once
        # Google specifies a hard limit of 100.
        # But an individual feed might have it's own, lower limit.
        #
        # * config.history = false 
        # Which is where the history option comes into play.
        # History pulls from Googls cache of the feed, not from the current
        # state of the feed. With this option you can fetch up to 100 items
        # from a feed that shows fewer than 100 at any given time.
        def config
          @config ||= OpenStruct.new(
            :version => '1.0',
            :limit   => 15,
            :history => false
          )
        end
        
        # Lookup will take any of these url formats:
        # * http://example.com
        # * http://example.com/
        # * http://www.example.com/
        # * www.example.com
        # * example.com/rss
        # * etc.
        #
        # And the object created will have the same Feed#canonical_id
        # Use of Feed#new is strongly discouraged
        def lookup url
          http_response = JSON.parse open(api.lookup_query(url)).read
          url = http_response["responseData"]["url"]
          new url
        end
        
        private        
        def api #:nodoc:
          API[config.version]
        end
      end
    
      # A canonical identifier for the feed. Feeds found with Feed#lookup
      # will have the some canonical_id even if the url used to find them
      # was not 100% the same. (Missing '/' etc.)
      def canonical_id
        @url
      end
      
      # true if the lookup returned a positive match for a feed
      def valid?
        not @url.nil?
      end

      # The link of the feed.      
      def link
        feed["link"]
      end
      
      # The author of the feed.
      def author
        feed["author"]
      end
      
      # The title of the feed.
      def title
        feed["title"]
      end
      
      # The description of the feed.
      def description
        feed["description"]
      end
      
      # List of Entry objects for this feed.
      def entries
        @entries ||= feed["entries"].map do |entry| 
          Entry.new(entry)
        end
      end
      
      private
      def load options={} #:nodoc:
        url = self.class.api.load_query @url, options
        
        # Very strange json bug. Bye bye tabs        
        http_response = JSON.parse open(url).read.gsub("\t", '')
        
        @feed = http_response["responseData"]["feed"]
        
        return @feed.length
      end
    
      private
      def feed #:nodoc:
        load if @feed.nil?
        @feed
      end
      
      private 
      def initialize url #:nodoc:
        @url = url
      end
    end
  end
end
