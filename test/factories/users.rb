FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }

    trait :oauth do
      provider { "google_oauth2" }
      uid { SecureRandom.uuid }
      password { nil }
      password_confirmation { nil }
    end
  end
end
