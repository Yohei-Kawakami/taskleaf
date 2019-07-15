FactoryBot.define do
    factory :task do
        name { 'Writing a test' }
        description { 'Prepare RSpec & Capybara & FactoryBot' }
        user
    end
end