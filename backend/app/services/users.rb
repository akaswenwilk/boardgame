class UserService
  def create(email:, password:, password_confirmation:)
    new_user_id = user_repo.create(
      email: email,
      password: password,
      password_confirmation: password_confirmation
    )

    user_repo.generate_token(user_id: new_user_id)
  end

  private

  def user_repo
    @user_repo ||= UserRepo.new
  end
end
