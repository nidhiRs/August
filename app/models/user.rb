class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :articles
  has_many :active_friendships, class_name: 'Friendship', foreign_key: 'follwer_id', dependent: :destroy
  has_many :followings, through: :active_friendships, source: :followed
  has_many :passive_friendships, class_name: 'Friendship', foreign_key: 'follwed_id', dependent: :destroy
  has_many :followers, through: :passive_friendships, source: :followed

  def follow(user)
    active_friendships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_friendships.find_by(followed_id: user.id).destroy
  end

  def following(user)
    folowing.include?(user)
  end
end
