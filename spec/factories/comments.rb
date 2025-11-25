FactoryBot.define do
  factory :comment do
    user { nil }
    commentable { nil }
    content { "MyText" }
  end
end
