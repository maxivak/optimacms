require 'rails_helper'

module Optimacms
  RSpec.describe Page, :type => :model do
    before :each do


    end

    describe 'validators' do

      it 'correct name' do
        # page-1 - ok ??
        # page_1 - ok
        # page1 - ok

        # page[1] - bad
        # page.name - bad
        # page(text) - bad
        # 1page - bad
        # page about - bad


      end

      it 'unique name' do

      end

    end

    describe 'basic' do
      before :each do


      end

      it 'save' do
        @page = build(:page_basic)

        expect{
          @page.save
        }.to change{Page.count}.by(1)



      end

      it 'content filename' do
        @page = build(:page_basic, name: 'page1')

        @page.save

        expect(@page.content_filename).to eq 'page1.html'
        expect(@page.content_filename('en')).to eq 'page1.en.html'
        expect(@page.content_filename('ru')).to eq 'page1.ru.html'

      end


      it 'save text to file' do

      end

      it 'read text from file' do

      end

      it "destroy" do

      end


    end


    describe 'main photo' do
      before :each do


      end

      it "add first photo for work - set main photo" do


      end


    end
  end

end
