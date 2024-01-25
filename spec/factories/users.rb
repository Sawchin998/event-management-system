# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { "Myname" }
    sequence(:email) { |n| "example#{n}@gmail.com" }
    password { "password123" }
  end
end
