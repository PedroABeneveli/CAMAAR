require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the HomeHelper. For example:
#
# describe HomeHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe HomeHelper, type: :helper do
  it "should identify an admin controller name" do
    expect(helper.is_gerenciamento("gerenciamento")).to eq(true)
  end

  it "should identify a non-admin controller name" do
    expect(helper.is_gerenciamento("blah")).to eq(false)
  end
end
