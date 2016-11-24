class User < ActiveRecord::Base

  # Adds methods to set and authenticate against a BCrypt password.
  # Validates:
  # - Password must be present on creation
  # - Password length should be less than or equal to 72 characters
  # - Confirmation of password (using a password_confirmation attribute)

  has_secure_password

  # Validations

  validates :email, presence: true
  validates :email, uniqueness: true

  validates :username, presence: true
  validates :username, format: { with: /\A[a-zA-Z0-9]+\Z/ }
  validates :username, length: { in: 3..20 }
  validates :username, uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 8 }, allow_nil: true
  validates :valid_email, inclusion: { in: [true, false] }

  # Callbacks

  before_validation { strip_email }
  before_validation { strip_username }
  after_create { valid_email_create_request }
  
  # Class Methods

  def self.signin_find(login)
    unless login.nil? or login.blank?
      where("LOWER(username) = :login OR LOWER(email) = :login", login: login.downcase).last
    else
      return nil
    end
  end

  # Modified Setter/Getter

  def remember_token=(remember_token)
    write_attribute(:remember_token, Digest::SHA1.hexdigest(remember_token.to_s))
  end

  # Methods

  def valid_email_create_request
    generate_token(:valid_email_token)
    self.valid_email_timestamp = Time.current
    if self.save
      UserMailer.valid_email_request(self).deliver_now
    end
  end

  def reset_password_create_request
    generate_token(:reset_password_token)
    self.reset_password_timestamp = Time.current
    if self.save
      UserMailer.valid_email_request(self).deliver_now
    end
  end

  private

  def strip_email
    unless self.email.nil?
      self.email = self.email.to_s
      self.email.downcase!
      self.email = self.email.strip
      self.email.gsub!(/[\p{Z}\t\f]/,"")
    end
  end
  
  def strip_username
    unless self.username.nil?
      self.username = self.username.to_s
      self.username = self.username.strip
      self.username.gsub!(/[\p{Z}\t\f]/,"")
    end
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
      return self[column]
    end while User.exists?(column => self[column])
  end

end
