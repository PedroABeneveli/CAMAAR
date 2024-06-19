FactoryBot.define do
  factory :student_form do
    name { "MyString" }
    semester { "MyString" }
    teacher { "MyString" }
    filled_in { false }
  end
end
