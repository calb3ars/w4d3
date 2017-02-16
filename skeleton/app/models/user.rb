# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base

  attr_reader :password

  validates :user_name, :session_token, presence: true, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}
  validates :password_digest, presence: {message: "Password cannot be empty"}

  after_initialize :ensure_session_token

  has_many :cats,
    class_name: :Cat,
    foreign_key: :user_id

  has_many :cat_rental_requests

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil if user.nil?
    return user if user.is_password?(password)
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  private
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end
