require 'rails_helper'

module Optimacms
  RSpec.describe PageServices::PageRouteService, :type => :model do
    before :each do

    end

    describe 'parse_url' do

      it 'parse empty' do
        u = ''
        r = PageServices::PageRouteService.parse_url u
        expect(r).to eq '^$'
      end

    end

    it 'parse simple' do
      r = PageServices::PageRouteService.parse_url 'about.html'
      expect(r).to eq '^about[.]html$'
    end

    it 'parse variables' do
      r = PageServices::PageRouteService.parse_url 'service-:name.html'
      expect(r).to eq '^service-([^/]+)[.]html$'
    end
  end

  describe 'url variables' do
    before :each do
      @service = PageServices::PageRouteService
    end

    it 'one variable' do
      # prepare
      u = 'service-hosting.html'
      page_url = 'service-:name.html'
      page_parsed_url = '^service-([^/]+)[.]html$'

      page_row = instance_double("Optimacms::Page", :url => page_url, :parsed_url=>page_parsed_url)

      # do
      res = @service.get_url_vars(u, page_row)

      # check
      expect(res).to have_key(:name)
      expect(res[:name]).to eq 'hosting'


    end
  end
end
