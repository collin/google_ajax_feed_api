require 'spec/helper'

describe Google::Ajax::Feed::API do
  it "has V1.0 constants" do
    GAF::API['1.0'].should_not be_nil
  end
  
  it "has 1.0 lookup endpoint" do
    GAF::API['1.0'].lookup.
      should == "http://ajax.googleapis.com/ajax/services/feed/lookup"
  end
  
  it "has 1.0 find endpoint" do
    GAF::API['1.0'].find.
      should == "http://ajax.googleapis.com/ajax/services/feed/find"
  end
  
  it "has 1.0 load endpoint" do
    GAF::API['1.0'].load.
      should == "http://ajax.googleapis.com/ajax/services/feed/load"
  end
  
  it "constructs 1.0 lookups" do
    blog_url = "http://someblog.com/?blog=franklins passion"
    GAF::API['1.0'].lookup_query(blog_url).
      should == "#{GAF::API['1.0'].lookup}?v=1.0&q=#{URI.encode blog_url}"
  end
  
  it "constructs 1.0 finds" do
    query = "senior superman's @w3s0me l33t <<>> machine"
    GAF::API['1.0'].find_query(query).
      should == "#{GAF::API['1.0'].find}?v=1.0&q=#{URI.encode query}"
  end
  
  it "constructs 1.0 loads" do
    blog_url = "http://someblog.com/?blog=franklins passion"
    GAF::API['1.0'].load_query(blog_url).
      should == 
      "#{GAF::API['1.0'].load}?v=1.0&q=#{URI.encode blog_url}&num=15"
  end
  
  it "constructs 1.0 loads with options" do
    blog_url = "http://someblog.com/?blog=franklins passion"
    GAF::API['1.0'].load_query(blog_url, :limit => 100, :history => true).
      should == 
      "#{GAF::API['1.0'].load}?v=1.0&q=#{URI.encode blog_url}&num=100&scoring=h"    
  end
  
  it "constructs 1.0 loads with config options" do
    blog_url = "http://someblog.com/?blog=franklins passion"
    GAF.config.history = true
    GAF::API['1.0'].load_query(blog_url).
      should == 
      "#{GAF::API['1.0'].load}?v=1.0&q=#{URI.encode blog_url}&num=15&scoring=h"  
    GAF.config.history = nil
  end
end
