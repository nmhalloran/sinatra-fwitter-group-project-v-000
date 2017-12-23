class User < ActiveRecord::Base
  has_secure_password
  has_many :tweets

  def self.find_by_slug(name)
    self.all.detect do |object|
      object.slug == name
    end
  end

  def slug
    self.username.downcase.gsub(/[ ]/, "-")
  end

  def self.current_user(session)
    @user = User.find_by_id(session[:user_id])
  end

  def self.is_logged_in?(session)
    !!session[:user_id]
  end
end
