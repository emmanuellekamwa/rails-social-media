FactoryBot.define do
  factory :friendships do
    user { FactoryBot.create(:user) }
    friend { FactoryBot.create(:second_user) }
    confirmed { true }
  end
  factory :second_friendship do
    user { FactoryBot.create(:second_user) }
    friend { FactoryBot.create(:user) }
    confirmed { false }
  end
end
