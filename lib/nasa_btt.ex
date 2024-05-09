defmodule NasaBtt do
  
  alias NasaBtt.Parser
  
  def main([initial_weight, locations]) do
    with {:ok, _weight} <- Parser.parse_weight(initial_weight),
         {:ok, _path} <- Parser.parse_locations(locations) do
         :ok
    else
    _ -> :ok
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