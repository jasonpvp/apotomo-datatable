require 'factory_girl'

FactoryGirl.define do
  factory :item do
    sequence(:name) { |n| "item#{n}" }
    sequence(:value) { |n| n }
  end
end
