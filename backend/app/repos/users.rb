require 'digest'
require 'securerandom'

class UserRepo
  PASSWORD_LENGTH = 8
  EMAIL_REGEX = /@/
  PASSWORD_REGEX = /[0-9]/

  def initialize
    @model = DB[:users]
  end

  def create(email:, password:, password_confirmation:)
    raise ValidationError.new("password confirmation does not match password") if password != password_confirmation
    raise ValidationError.new("email is invalid") unless email.match?(EMAIL_REGEX)
    raise ValidationError.new("password must be at least #{PASSWORD_LENGTH} characters long") unless password.length >= PASSWORD_LENGTH
    raise ValidationError.new("password needs to have at least one number") unless password.match?(PASSWORD_REGEX)

    begin
      @model.insert(email: email, password: Digest::SHA256.hexdigest(password))
    rescue Sequel::UniqueConstraintViolation => e
      raise ValidationError.new("email already taken")
    end
  end

  def generate_token(user_id:)
    token = SecureRandom.base64(12)
    result = @model.where(id: user_id).update(token: token)
    raise ModelNotFoundError.new("could not find user with id: #{user_id}") if result == 0

    token
  end

  def authenticate(email:, password:)
    encrypted_password = Digest::SHA256.hexdigest(password)

    user = @model.where(email: email, password: encrypted_password).first
    raise ModelNotFoundError.new("No user found with this email and password") unless user
    user[:id]
  end

  def find_by_token(token)
    user = @model.where(token: token).first
    raise ModelNotFoundError.new("No user found with this token") unless user

    user
  end
end
