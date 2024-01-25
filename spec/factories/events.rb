# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    title { "title" }
    sequence(:date) { |n| n.days.after }
    location { "location" }
    category { :sports }
    creator

    trait :creator do
      association :creator, factory: :user
    end
  end
end
