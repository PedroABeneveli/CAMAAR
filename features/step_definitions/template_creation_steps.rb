Then('I should have a template created with name {string}') do |t|
  @template = Template.find_by(name: t)
  expect(@template).to_not be_nil
end