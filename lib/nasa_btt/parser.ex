defmodule NasaBtt.Parser do
  
  @moduledoc """
  Module for initial parsing of arguments
  """
 
  @doc """
  Parse the weight to retrieve an integer value
  
  ## Examples
  
    iex> NasaBtt.Parser.parse_weight(10)
    {:ok, 10}
    
    iex> NasaBtt.Parser.parse_weight("10")
    {:ok, 10}
    
    iex> NasaBtt.Parser.parse_weight("10a")
    {:error, :nan}
    
    iex> NasaBtt.Parser.parse_weight("asdf")
    {:error, :nan}
  """
  @spec parse_weight(weight :: any()) :: {:ok, integer()} | {:error, :nan}
  def parse_weight(weight) when is_integer(weight) do
    {:ok, weight}
  end
  
  def parse_weight(weight) when is_bitstring(weight) do
    case Integer.parse(weight) do
      {number, ""} -> 
        {:ok, number}
        
      _ ->
        {:error, :nan}
    end
  end
  
  def parse_weight(_), do: {:error, :nan}
  
  @doc """
  Parse the flight path from a string.
  
  ## Examples
  
    iex> NasaBtt.Parser.parse_locations("[{:launch, \\"earth\\"}, {:land, \\"moon\\"}, {:launch, \\"moon\\"}, {:land, \\"earth\\"}]")
    {:ok, [launch: "earth", land: "moon", launch: "moon", land: "earth"]}
    
    iex> NasaBtt.Parser.parse_locations("[{:launch, \\"earth\\"}]")
    {:error, :not_a_path}
    
    iex> NasaBtt.Parser.parse_locations("[{:launch, \\"earth\\"}]")
    {:error, :not_a_path}
    
    iex> NasaBtt.Parser.parse_locations("[{:launch, \\"earth\\"}, {:none, \\"moon\\"}, {:launch, \\"moon\\"}, {:land, \\"earth\\"}]")
    {:error, :not_a_path}
  """
  def parse_locations(locations) when is_bitstring(locations) do
    # I could do Code.eval/2 but that's a big NONO
    
    path =
      locations
      |> String.replace(" ", "")
      |> then(&Regex.scan(~r/{:(launch|land),\"(earth|moon|mars)\"/, &1))
      |> Enum.map(&List.delete_at(&1, 0))
      |> Enum.map(&to_path_struct/1)
      
    with 0 <- rem(Enum.count(path), 2),
         true <- Enum.count(path) > 0 do
      {:ok, path}
    else
      _ -> {:error, :not_a_path}
    end
  end
  
  defp to_path_struct([action, location]) do
    {String.to_atom(action), location}
  end
  
  def sanitize_path(path) do
    path
    |> Enum.map(fn {action, location} -> "#{action} #{location |> String.capitalize()}" end)
    |> Enum.join(", ")
  end
end