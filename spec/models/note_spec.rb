require 'rails_helper'

RSpec.describe Note, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:taggings) }
  it { should have_many(:tags).through(:taggings) }

  context "callback methods" do
    before(:each) do
      @user = User.create(
        email: 'foobar@foobar.com',
        password: 'foobar',
        password_confirmation: 'foobar'
      )
    end

    describe "#create_tags" do
      it "creates new tags when a note is created with new tags" do
        @user.notes.create(
          title: '#hashtag1 @mention1 foobar',
          body: '#hashtag2 @mention2 foobar',
        )
        expect(Tag.find_by(name: 'hashtag1', mention: false)).to be
        expect(Tag.find_by(name: 'hashtag2', mention: false)).to be
        expect(Tag.find_by(name: 'mention1', mention: true)).to be
        expect(Tag.find_by(name: 'mention2', mention: true)).to be
      end

      it "creates new associations when a note is created with existing tags" do
        note1 = @user.notes.create(
          title: '#hashtag1 @mention1 foobar',
          body: '#hashtag2 @mention2 foobar'
        )

        note2 = @user.notes.create(
          title: '#hashtag1 @mention1 foobaz',
          body: '#hashtag2 @mention2 foobaz'
        )

        expect(Tag.all.count).to eq(4)
        expect(note2.tags.find_by(name: 'hashtag1', mention: false)).to be
        expect(note2.tags.find_by(name: 'hashtag2', mention: false)).to be
        expect(note2.tags.find_by(name: 'mention1', mention: true)).to be
        expect(note2.tags.find_by(name: 'mention2', mention: true)).to be
      end

      it "won't create duplicate taggings when updating notes" do
        note = @user.notes.create(title: '#hashtag')
        note.update!(title: note.title += ' foo')
        expect(Tagging.all.count).to eq(1)
      end
    end
  end
end
