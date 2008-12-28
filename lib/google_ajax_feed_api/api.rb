module Google
  module Ajax
    class Feed
      module API #:nodoc:
        def self.[] version
          case version
          when '1.0'
            OneZero
          end
        end
      end
    end
  end
end
