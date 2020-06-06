class ApiException < StandardError
  attr_reader :message, :code

  def initialize(message, code=500)
    @message = message
    @code = code
  end
end

class ValidationError < ApiException
  def initialize(message)
    @message = message
    @code = 400
  end
end

class ModelNotFoundError < ApiException
  def initialize(message)
    @message = message
    @code = 404
  end
end

class AuthenticationError < ApiException
  def initialize(message)
    @message = message
    @code = 403
  end
end

class InvalidParamsError < ApiException
  def initialize(message)
    @message = message
    @code = 400
  end
end
