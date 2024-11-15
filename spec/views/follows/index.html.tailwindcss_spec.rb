require 'rails_helper'

RSpec.describe "follows/index", type: :view do
  before(:each) do
    assign(:follows, [
      Follow.create!(
        follower: nil,
        followed: nil
      ),
      Follow.create!(
        follower: nil,
        followed: nil
      )
    ])
  end

  it "renders a list of follows" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
