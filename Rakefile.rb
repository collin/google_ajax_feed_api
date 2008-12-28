require 'rubygems'
require 'pathname'
require 'spec'

__DIR__ = Pathname.new(__FILE__).dirname

task :default => 'spec:all'

namespace :spec do
  task :prepare do
    @specs= Dir.glob("#{__DIR__}/spec/**/*.rb").join(' ')
  end

  task :all => :prepare do
    system "spec #{@specs}"
  end
  
  task :doc => :prepare do
    system "spec #{@specs} --format specdoc"
  end
end

task :cleanup do 
  Dir.glob("**/*.*~")+Dir.glob("**/*~").each{|swap|FileUtils.rm(swap, :force => true)}
end

namespace :gem do
  task :version do
    @version = "0.0.2"
  end

  task :build => :spec do
    load __DIR__ + "google_ajax_feed_api.gemspec"
    Gem::Builder.new(@google_ajax_feed_api_gemspec).build
  end

  task :install => :build do
    cmd = "gem install google_ajax_feed_api -l"
    system cmd unless system "sudo #{cmd}"
    FileUtils.rm(__DIR__ + "google_ajax_feed_api-#{@version}.gem")
  end

  task :spec => :version do
    file = File.new(__DIR__ + "google_ajax_feed_api.gemspec", 'w+')
    FileUtils.chmod 0755, __DIR__ + "google_ajax_feed_api.gemspec"
    spec = %{
Gem::Specification.new do |s|
  s.name             = "google_ajax_feed_api"
  s.version          = "#{@version}"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.has_rdoc         = true
  s.summary          = "Light wrapper for Google Ajax Feed API"
  s.authors          = ["Collin Miller"]
  s.email            = "collintmiller@gmail.com"
  s.homepage         = "http://github.com/collin/fold"
  s.files            = %w{#{(%w(README Rakefile.rb) + Dir.glob("{lib,spec}/**/*")).reject{|path| path.match /~$/ }.join(' ')}}
  
  s.add_dependency  "rake"
  s.add_dependency  "rspec"
  s.add_dependency  "json"
  s.add_dependency  "extlib"
end
}

  @google_ajax_feed_api_gemspec = eval(spec)
  file.write(spec)
  end
end
