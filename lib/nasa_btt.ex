defmodule NasaBtt do
  
  alias NasaBtt.Parser
  
  @spec main(any()) :: none()
  def main([initial_weight, locations]) do
    with {:ok, weight} <- Parser.parse_weight(initial_weight) do
      
    end
    
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