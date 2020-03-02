# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#
class User < ApplicationRecord 
  validates :username, :session_token, presence: true, uniqueness: true 
  validates :password_digest, presence: true
  after_initialize :ensure_session_token  

  attr_reader :password 

  def self.generate_session_token 
    SecureRandom::urlsafe_base64
  end

  def self.find_by_credentials(user_name, password)
    # debugger
    user = User.find_by(username: user_name)
    # debugger
    return nil unless user && user.is_password?(password)
    user
  end

  def reset_session_token! 
    self.update!(session_token: self.class.generate_session_token)
    self.session_token
  end

  def password=(password)
    @password = password

    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    # debugger
    bcrypt_password = BCrypt::Password.new(self.password_digest)
    # debugger
    bcrypt_password.is_password?(password)
  end

  def ensure_session_token 
    self.session_token ||= self.class.generate_session_token
  end

  has_many :cats,
  foreign_key: :user_id,
  class_name: :Cat

end
