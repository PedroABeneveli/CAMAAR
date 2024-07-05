Given "I have started template {string}" do |t|
  @template = FactoryBot.create(:template, name: t)
end

Then('I should have a template with name {string}') do |t|
  Template.find_by(name: t).should_not be_nil
end

Then('I should have a template with question {string}') do |q|
  TemplateQuestion.find_by(title: q).should_not be_nil
end

Then('I should have a hidden template {string}') do |t|
  template = Template.find_by(name: t)
  expect(template.hidden).to be(true)
end

Then('the already created forms should not be affected') do
  expect(page).to have_content('Existing Form 1')
  expect(page).to have_content('Existing Form 2')
end

Then('the template should be deleted successfully') do
  expect(page).to have_content('Template deleted successfully')
end

Then('the template should not be updated') do
  expect(page).to have_content('Error updating template')
end
