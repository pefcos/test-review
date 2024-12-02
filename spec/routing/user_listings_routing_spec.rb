require 'rails_helper'

RSpec.describe UserListingsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/user_listings').to route_to('user_listings#index')
    end

    it 'routes to #show' do
      expect(get: '/user_listings/1').to route_to('user_listings#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/user_listings').to route_to('user_listings#create')
    end

    it 'routes to #destroy' do
      expect(delete: '/user_listings/1').to route_to('user_listings#destroy', id: '1')
    end
  end
end
