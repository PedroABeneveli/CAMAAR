Given('There are classes {string} and {string}') do |c1, c2|
  @c1 = FactoryBot.create(:study_class, name: c1)
  @c2 = FactoryBot.create(:study_class, name: c2)
end

When "I check class {string}" do |c|
  if @c1.name == c
    check("study_class_#{@c1.id}")
  elsif @c2.name == c
    check("study_class_#{@c2.id}")
  else
    assert false
  end
end