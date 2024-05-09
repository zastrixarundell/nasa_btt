defmodule NasaBtt.Gravitas do
  @moduledoc """
  Map of gravity factors of celestial bodies
  """
  
  def find!("earth") do
    9.807
  end
  
  def find!("moon") do
    1.62
  end
  
  def find!("mars") do
    3.711
  end
  
  def find!(_) do
    IO.puts(:stderr, "Gravity is unknown!")
    System.halt(2)
  end
end