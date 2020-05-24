require 'digest'
require 'securerandom'

class UserRepo

  def initialize
    @model = DB[:users]
  end

  def create(user:, password_confirmation:)
    raise ValidationError.new("password confirmation does not match password") unless user.match_password?(password_confirmation)

    begin
      id = @model.insert(**user.attributes(true))
      user.id = id

      user
    rescue Sequel::UniqueConstraintViolation => e
      raise ValidationError.new("email already taken")
    end
  end

  def generate_token(user:)
    token = SecureRandom.base64(12)
    result = @model.where(id: user.id).update(token: token)
    raise ModelNotFoundError.new("could not find user with id: #{user.id}") if result == 0

    token
  end

  def authenticate(user:)
    encrypted_password = Digest::SHA256.hexdigest(user.password)

    attributes = @model.where(email: user.email, password: encrypted_password).first
    user = User.new(attributes)
    raise ModelNotFoundError.new("No user found with this email and password") unless user.saved?

    user
  end

  def find_by_token(token)
    attributes = @model.where(token: token).first
    user = User.new(attributes)
    raise ModelNotFoundError.new("No user found with this token") unless user.saved?

    user
  end
end
