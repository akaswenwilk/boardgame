class GameRepo
  def initialize
    @model = DB[:games]
  end

  def create
    @model.insert
  end
end
