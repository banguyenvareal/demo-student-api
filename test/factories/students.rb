FactoryBot.define do
  factory :student do
    name { "MyString" }
    user_id { rand(1..20) }
  end
end
