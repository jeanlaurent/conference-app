require 'spec_helper'
require 'party/url_helper'

describe Party::UrlHelper do
  describe 'conference_path_for' do
    before do
      extend(Party::UrlHelper)
    end

    it 'should make conferences/deep/2011 with a Hash' do
      conference_path(:name => 'deep', :edition => 2011).should == 'conferences/deep/2011'
    end

    it 'should make path out a conference' do
      deep = Factory(:conference, :name => 'deep', :edition => '2011')
      conference_path(deep).should ==  'conferences/deep/2011'
    end
  end
end