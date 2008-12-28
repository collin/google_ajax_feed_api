require 'spec/helper'

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

