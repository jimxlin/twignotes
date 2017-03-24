class Note < ApplicationRecord
  belongs_to :user
  has_many :taggings
  has_many :tags, through: :taggings, dependent: :destroy

  after_save :create_tags
  after_destroy :destroy_orphan_tags

  private

  def create_tags
    hashtags = extract_hashtags(self.title) + extract_hashtags(self.body)
    mentions = extract_mentions(self.title) + extract_mentions(self.body)

    if hashtags.empty? && mentions.empty?
      nulltag = '00000000NULLTAG00000000'
      tag = Tag.all.find_by(name: nulltag)
      tag ? self.tags << tag : self.tags.create(name: nulltag, mention: false)
    end

    hashtags.each do |name|
      tag = self.user.tags.find_by(name: name, mention: false);
      tag ? self.tags << tag : self.tags.create(name: name, mention: false)
    end

    mentions.each do |name|
      tag = self.user.tags.find_by(name: name, mention: true)
      tag ? self.tags << tag : self.tags.create!(name: name, mention: true)
    end
  end

  # takes too long?
  #   before_destroy: check tags
  # use def destroy ... super... end
  def destroy_orphan_tags
    Tag.all.each { |tag| tag.delete if tag.notes.empty? }
  end

  def extract_hashtags(str)
    str.scan(/#\S+/).map {|tag| tag[1..-1]}.uniq
  end

  def extract_mentions(str)
    str.scan(/@\S+/).map {|tag| tag[1..-1]}.uniq
  end
end
