FactoryBot.define do
  factory :data_log do
    operation { SystemOperations.all.sample }
    note { Faker::Lorem.sentence(word_count: 12) }
    meta { Faker::Json.shallow_json(width: 3) }
    original_data { Faker::Json.shallow_json(width: 3) }
  end
end
