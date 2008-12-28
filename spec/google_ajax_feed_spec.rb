require 'lib/feed'
require 'rubygems'
require 'spec'

GAF = Google::Ajax::Feed

describe Google::Ajax::Feed::Entry do
  before :each do
    @feed = GAF.lookup('http://ajaxian.com')
    @entry = @feed.entries.first
  end
  
  describe "entry" do
    it "exposes title" do
      @entry.title.should_not be_nil
    end
    
    it "exposes link" do
      @entry.link.should_not be_nil
    end
    
    it "exposes author" do
      @entry.author.should_not be_nil
    end
    
    it "exposes content" do
      @entry.content.should_not be_nil
    end
    
    it "exposes snippet" do
      @entry.snippet.should_not be_nil
    end
  end
end

describe Google::Ajax::Feed do
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
    query = "senior supermans @w3s0me l33t <<>> machine"
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
  
  it "has configuration" do
    GAF.config.should be_is_a(OpenStruct)
  end
  
  it "has default version" do
    GAF.config.version.should == '1.0'
  end
  
  it "has default number to load" do
    GAF.config.limit.should == 15
  end
  
  it "api set from config" do
    GAF.api.should == GAF::API['1.0']
  end
  
  it "looks up feeds" do
    GAF.lookup('http://ajaxian.com').should_not be_nil
  end
   
  it "validates feeds" do
    GAF.new(nil).should_not be_valid
  end
   
  it "loads feed" do
    f = GAF.lookup('http://ajaxian.com')
    f.load
    f.feed.should_not be_nil
  end
  
  describe "feed attributes" do
    before :each do
      @feed = GAF.lookup('http://ajaxian.com')   
    end
    
    it "exposes title" do
      @feed.title.should == "Ajaxian » Front Page"
    end
    
    it  "exposes link" do
      @feed.link.should == "http://ajaxian.com"
    end
    
    it "exposes author" do
      @feed.author.should == ""
    end
    
    it "exposes description" do
      @feed.description.should == "Cleaning up the web with Ajax"
    end
    
    it "exposes entries" do
      @feed.entries.should be_is_a(Array)
    end
  end
   
  it "feeds have canonical_id" do
    a= GAF.lookup('http://ajaxian.com')
    b= GAF.lookup('http://www.ajaxian.com')
    c= GAF.lookup('http://ajaxian.com/')
    d= GAF.lookup('http://www.ajaxian.com/')
    e= GAF.lookup('http://ajaxian.com/index.xml')
    
    a.canonical_id.should_not be_nil
    a.canonical_id.should == b.canonical_id
    a.canonical_id.should == c.canonical_id
    a.canonical_id.should == d.canonical_id
    a.canonical_id.should == e.canonical_id
  end
end
