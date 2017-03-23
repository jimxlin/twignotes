class User < ApplicationRecord
  has_many :notes
  has_many :tags, through: :notes
  has_many :taggings, through: :notes

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
