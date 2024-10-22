class State
  # initial - Boolean
  # final - Boolean
  # name - String
  attr_accessor :initial, :final, :name

  def initialize(initial: nil, final: nil, name: nil)
    @initial = initial
    @final = final
    @name = name
  end
end