FactoryBot.define do
    factory :user do
        name { 'Test user' }
        email { 'test1@example.com' }
        password { 'password' }
    end
end