
Gem::Specification.new do |s|
  s.name             = "google_ajax_feed_api"
  s.version          = "0.0.4"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.has_rdoc         = true
  s.summary          = "Light wrapper for Google Ajax Feed API"
  s.authors          = ["Collin Miller"]
  s.email            = "collintmiller@gmail.com"
  s.homepage         = "http://github.com/collin/fold"
  s.files            = %w{README Rakefile.rb lib/google_ajax_feed_api lib/google_ajax_feed_api/api.rb lib/google_ajax_feed_api/api lib/google_ajax_feed_api/api/one_zero.rb lib/google_ajax_feed_api/entry.rb lib/google_ajax_feed_api/feed.rb lib/google_ajax_feed_api.rb spec/api_spec.rb spec/entry_spec.rb spec/helper.rb spec/feed_spec.rb}
  
  s.add_dependency  "rake"
  s.add_dependency  "rspec"
  s.add_dependency  "json"
  s.add_dependency  "extlib"
end
