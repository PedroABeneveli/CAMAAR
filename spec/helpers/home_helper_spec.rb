require 'rails_helper'

RSpec.describe HomeHelper, type: :helper do
  it "should identify an admin controller name" do
    expect(helper.is_gerenciamento("gerenciamento")).to eq(true)
  end

  it "should identify a non-admin controller name" do
    expect(helper.is_gerenciamento("blah")).to eq(false)
  end
end
