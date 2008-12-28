require 'spec/helper'

describe Google::Ajax::Feed do
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
