class AuthenticationService
  def authenticate(token:, admin_only: false)
    begin
      user = user_repo.find_by_token(token)
    rescue ModelNotFoundError
      raise AuthenticationError.new("Please login first")
    end

    raise AuthenticationError.new("You must be an admin to do that") if admin_only && !user.is_admin?

    user
  end

  private

  def user_repo
    @user_repo ||= UserRepo.new
  end
end
