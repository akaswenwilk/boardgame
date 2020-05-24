class User
  attr_accessor :email, :password, :id

  EMAIL_REGEX = /@/
  PASSWORD_REGEX = /[0-9]/
  PASSWORD_LENGTH = 8

  def initialize(params)
    @email = params&.fetch(:email, nil)
    @password = params&.fetch(:password, nil)
    @id = params&.fetch(:id, nil)
  end

  def saved?
    id != nil
  end

  def match_password?(test_password)
    password == test_password
  end

  def validate!
    return if saved?

    raise ValidationError.new("email is invalid") unless email.match?(EMAIL_REGEX)
    raise ValidationError.new("password must be at least #{PASSWORD_LENGTH} characters long") unless password.length >= PASSWORD_LENGTH
    raise ValidationError.new("password needs to have at least one number") unless password.match?(PASSWORD_REGEX)
  end

  def attributes(digested_password = false)
    self.password = Digest::SHA256.hexdigest(self.password) if digested_password

    attributes = {
      email: email,
      password: password
    }
    attributes.merge!({id: id}) if id

    attributes
  end
end
