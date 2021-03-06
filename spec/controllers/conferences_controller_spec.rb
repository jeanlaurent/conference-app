#encoding: utf-8
require 'spec_helper'

describe ConferencesController do
  describe "GET 'show'" do
    describe 'with existing conference params' do
      touch_db_with(:deep) {Fabricate(:conference, :name => 'deep', :edition => '2011')}
      it "should be successful for an existing conference" do
        get :show, {:id => @deep.id}
        response.should be_success
      end
    end

    describe 'with flunky parameters' do
      before do
        get :show, {:id => id(2)}
      end

      it 'should redirect to root_path' do
        response.should redirect_to root_path
      end

      it 'should flash ya' do
        flash[:error].should_not be_nil
      end
    end
  end

  describe 'index' do
    it 'should show available conferences' do
      conferences = (2030..2032).map {|edition| Fabricate(:conference, :name => 'deep', :edition => edition)}
      get :index
      # assigned conferences is all conferences, unordered
      assigned_conferences = assigns(:conferences).to_a
      assert {assigned_conferences.size == conferences.size}
      assigned_conferences.each do |c|
        assert {conferences.include? c}
      end
      response.should be_success
    end
  end
end
