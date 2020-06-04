class User
  attr_accessor :email, :password, :id, :admin, :token

  EMAIL_REGEX = /@/
  PASSWORD_REGEX = /[0-9]/
  PASSWORD_LENGTH = 8

  def initialize(params = {})
    params = params&.with_indifferent_access
    @email = params&.fetch(:email, nil)
    @password = params&.fetch(:password, nil)
    @id = params&.fetch(:id, nil)
    @admin = params&.fetch(:admin, false)
    @token = params&.fetch(:token, nil)
  end

  def saved?
    id != nil
  end

  def is_admin?
    admin
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

    {
      id: id,
      email: email,
      password: password,
      token: token,
      admin: admin
    }.compact
  end
end
