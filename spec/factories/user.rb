FactoryBot.define do
  factory :user do
    email { "user@example.com" }
    matricula { "220000000" }
    tipo { "student" }
    password { "pass123" }
    is_admin { false }
  end
end