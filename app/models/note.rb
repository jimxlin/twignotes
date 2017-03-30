class Note < ApplicationRecord
  belongs_to :user
  has_many :taggings
  has_many :tags, through: :taggings, dependent: :destroy

  after_save :create_tags

  scope :unarchived, -> { where(is_archived: false) }
  scope :archived, -> { where(is_archived: true) }

  private

  def create_tags
    hashtags = (extract_hashtags(title) + extract_hashtags(body)).uniq
    mentions = (extract_mentions(title) + extract_mentions(body)).uniq

    # Prevent creating duplicate taggings during updates
    # p '==================================='
    # p hashtags
    # p mentions
    existing_tag_names = tags.map { |t| t.name }
    hashtags = hashtags.reject { |t| existing_tag_names.include?(t) }
    mentions = mentions.reject { |t| existing_tag_names.include?(t) }
    # p '--'
    # p existing_tag_names
    # p '--'
    # p hashtags
    # p mentions

    hashtags.each do |name|
      tag = user.tags.find_by(name: name, mention: false);
      tag ? tags << tag : tags.create(name: name, mention: false, user_id: user.id)
    end

    mentions.each do |name|
      tag = user.tags.find_by(name: name, mention: true)
      tag ? tags << tag : tags.create(name: name, mention: true, user_id: user.id)
    end
  end

  def extract_hashtags(str)
    str ? str.scan(/#\S+/).map {|tag| tag[1..-1]}.uniq : []
  end

  def extract_mentions(str)
    str ? str.scan(/@\S+/).map {|tag| tag[1..-1]}.uniq : []
  end
end
