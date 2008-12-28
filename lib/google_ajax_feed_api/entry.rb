module Google
  module Ajax
    class Feed
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

        def initialize data #:nodoc:
          @data = data
        end
      end
    end
  end
end
