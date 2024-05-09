defmodule NasaBtt do
  
  #alias NasaBtt.Parser
  
  def main([_initial_weight, _locations]) do
        
    System.halt()
  end
  
  
  def main(_args) do
    IO.puts(
      :stderr,
      "Either the weight or location is missing! " <>
        "Please run the command with the following format: " <>
        "./nasa_btt WEIGHT '[{:launch, \"earth\"}, {:land, \"moon\"}, {:launch, \"moon\"}, {:land, \"earth\"}]")
  end
  
end