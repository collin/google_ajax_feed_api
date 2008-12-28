module Google #:nodoc:
  module Ajax #:nodoc:
    class Feed
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
      
      def load options={} #:nodoc:
        url = self.class.api.load_query @url, options
        
        # Very strange json bug. Bye bye tabs        
        http_response = JSON.parse open(url).read.gsub("\t", '')
        
        @feed = http_response["responseData"]["feed"]
        
        return @feed.length
      end
    
      def feed #:nodoc:
        load if @feed.nil?
        @feed
      end
      
      def initialize url #:nodoc:
        @url = url
      end
    end
  end  
end
