require 'rails_helper'

RSpec.describe Friendship, type: :model do
  describe 'creation' do
    before do
      @user1 = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:second_user)
      @friendship = Friendship.create(user: @user1, friend: @user2, confirmed: true)
    end

    it 'should be able to be created if valid' do
      expect(@friendship).to be_valid
    end

    it 'increased the count of friendships' do
      Friendship.create(user: @user1, friend: @user2, confirmed: true)
      expect(Friendship.count).to eq 2
    end
  end

  context 'associations' do
    it 'should belongs to user' do
      t = Friendship.reflect_on_association(:user)
      expect(t.macro).to eq(:belongs_to)
    end
  end
end
