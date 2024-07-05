Given('I have created two templates {string} and {string}') do |t1, t2|
  FactoryBot.create(:template, name: t1)
  FactoryBot.create(:template, name: t2)
end

Given('I have deleted template {string}') do |t|
  Template.delete_by(name: t)
end