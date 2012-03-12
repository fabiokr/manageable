FactoryGirl.define do
  factory :article do
    title         { "My article" }
    description   { "My article description" }
    excerpt       { "My article excerpt" }
    content       { "My article content" }
    published_at  { DateTime.now + rand(1000) }
    highlight     { true }
    locale        { I18n.locale }
  end
end