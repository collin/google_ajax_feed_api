require 'rubygems'
require 'ostruct'
require 'extlib'
require 'json'
require 'open-uri'

$LOAD_PATH << File.dirname(__FILE__)

module Google #:nodoc:
  module Ajax #:nodoc:

    require 'google_ajax_feed_api/feed'
    require 'google_ajax_feed_api/entry'
    require 'google_ajax_feed_api/api'
    require 'google_ajax_feed_api/api/one_zero'

  end
end
