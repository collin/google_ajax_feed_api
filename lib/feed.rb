require 'rubygems'
require 'ostruct'
require 'extlib'
require 'json'
require 'uri'
require 'open-uri'

module Google
  module Ajax
    class Feed
      class Entry
        def initialize data
          @data = data
        end
        
        def inspect
          "<#Google::Ajax::Feed::Entry link=#{link} title=#{title}>"
        end 
        
        def link
          @data["link"]
        end
        
        def title
          @data["title"]
        end

        def content
          @data["content"]
        end        

        def snippet
          @data["contentSnippet"]
        end        

        def author
          @data["author"]
        end        

        def created_at
          @data["publishedDate"]
        end        
      end
    
      module API
        def self.[] version
          case version
          when '1.0'
            OneZero
          end
        end
        
        class OneZero
          class << self
            def lookup
              "http://ajax.googleapis.com/ajax/services/feed/lookup"
            end
            
            def find
              "http://ajax.googleapis.com/ajax/services/feed/find"
            end
            
            def load 
              "http://ajax.googleapis.com/ajax/services/feed/load"
            end
        
            def lookup_query url
              "#{lookup}#{params url}"
            end
            
            def find_query query
              "#{find}#{params query}"
            end
            
            def load_query url, options={}
              "#{load}#{params url}#{load_params options}"
            end
            
            def load_params options={}
              options = ({
                :limit => Feed.config.limit,
                :history => nil,
                :output => nil
              }).merge(options)
              
              params = "&num=#{options[:limit]}"
              params << '&scoring=h' if options[:history]
              params        
            end
            
            def params query
              "?v=1.0&q=#{URI.encode query}"
            end
          end
        end
      end

      cattr_accessor :config

      self.config = OpenStruct.new(
        :version => '1.0',
        :limit => 15
      )
    
      def initialize url
        @url = url
      end
      
      def canonical_id
        @url
      end
      
      def valid?
        not @url.nil?
      end
      
      def link
        feed["link"]
      end
      
      def author
        feed["author"]
      end
      
      def title
        feed["title"]
      end
      
      def entries
        @entries ||= feed["entries"].map do |entry| 
          Entry.new(entry)
        end
      end
      
      def description
        feed["description"]
      end
      
      def load options={}
        url = self.class.api.load_query @url, options
        http_response = JSON.parse open(url).read
        @feed = http_response["responseData"]["feed"]
      end
    
      def feed
        load if @feed.nil?
        @feed
      end
    
      class << self     
        def api
          API[config.version]
        end
        
        def lookup url
          http_response = JSON.parse open(api.lookup_query(url)).read
          url = http_response["responseData"]["url"]
          new url
        end
      end
    end
  end
end
