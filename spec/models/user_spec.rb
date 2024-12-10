require 'rails_helper'

RSpec.describe User, type: :model do
  context 'name' do
    it 'should be valid when name is present' do
      user = User.new name: 'UserName', email: 'email@user.com', password: '123456789'

      expect(user).to be_valid
    end

    it 'should be invalid when name is nil' do
      user = User.new name: nil, email: 'email@user.com', password: '123456789'

      expect(user).to_not be_valid
    end

    it 'should be invalid when name is blank' do
      user = User.new name: '', email: 'email@user.com', password: '123456789'

      expect(user).to_not be_valid
    end
  end
end
