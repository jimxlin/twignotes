require 'rails_helper'

RSpec.describe Tagging, type: :model do
  it { should belong_to(:note) }
  it { should belong_to(:tag) }

  context "callback methods" do
    before(:each) do
      @user = User.create(
        email: 'foobar@foobar.com',
        password: 'foobar',
        password_confirmation: 'foobar'
      )
    end

    describe "#destroy_orphan_tag" do
      it "destroys orphan tags" do
        note1 = @user.notes.create(title: 'note1 #hashtag1')
        note2 = @user.notes.create(title: 'note2 #hashtag1')
        note1.destroy
        expect(Tag.all.count).to eq(1)
        note2.destroy
        expect(Tag.all.count).to eq(0)
      end
    end

    describe "#update_note_count_for_tag" do
      it "updates note_count for tags" do
        note1 = @user.notes.create(title: 'note1 #hashtag1')
        expect(Tag.first.note_count).to eq(1)
        note2 = @user.notes.create(title: 'note2 #hashtag1')
        expect(Tag.first.note_count).to eq(2)
      end
    end

    describe "#update_note_count_for_tag_on_destroy" do
      it "updates note_count for tags when note is destroyed" do
        note1 = @user.notes.create(title: 'note1 #hashtag1')
        note2 = @user.notes.create(title: 'note2 #hashtag1')
        expect(Tag.first.note_count).to eq(2)
        note1.destroy
        expect(Tag.first.note_count).to eq(1)
      end
    end
  end
end
