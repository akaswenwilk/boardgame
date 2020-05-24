class UserService
  def create(params)
    password_confirmation = params.delete(:password_confirmation)
    user = User.new(params)
    user.validate!

    user = user_repo.create(
      user: user,
      password_confirmation: password_confirmation
    )

    user_repo.generate_token(user: user)
  end

  def login(params)
    user = User.new(params)
    user = user_repo.authenticate(user: user)
    user_repo.generate_token(user: user)
  end

  private

  def user_repo
    @user_repo ||= UserRepo.new
  end
end
