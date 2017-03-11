require 'rails_helper'

RSpec.describe Tagging, type: :model do
  it { should belong_to(:note) }
  it { should belong_to(:tag) }
end
