FactoryBot.define do
  factory :employee do
    full_name { Faker::Name.name }
    email     { Faker::Internet.unique.email }
    job_title { "Software Engineer" }
    country   { "India" }
    salary    { rand(30000..100000) }
    currency  { "INR" }
    employment_type { :full_time }
  end
end
