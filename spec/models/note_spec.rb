require 'rails_helper'

RSpec.describe Note, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:taggings) }
  it { should have_many(:tags).through(:taggings) }
end
