defmodule NasaBtt.Servers.FuelCalcullator do
  use GenServer

  alias NasaBtt.Gravitas

  # Client-side

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @doc """
  Send a request to get the fuel information. Eventually a message will be sent to the calling process with
  the following format: `{:calculated_weight, weight, fuel_weight}`.
  """
  @spec request_fuel(weight :: integer(), path :: [{action :: :land | :launch, celestial_body :: bitstring()}], pid :: pid()) :: :ok
  def request_fuel(weight, path, pid) do
    GenServer.cast(pid, {:request_fuel, weight, path, self()})
  end

  # Server-side

  def init(%{}) do
    {:ok, %{}}
  end

  def handle_cast({:request_fuel, weight, path, calling_pid}, state) do
    Task.start_link(fn ->
      calculate_fuel(weight, path)
      |> then(&send(calling_pid, {:calculated_weight, weight, &1}))
    end)

    {:noreply, state}
  end

  # Implementation-wise

  @doc """
  Calculate the fuel required for a path.

  ## Examples

    iex> NasaBtt.Servers.FuelCalcullator.calculate_fuel(28801, [{:launch, "earth"},{:land, "moon"},{:launch, "moon"},{:land, "earth"}])
    51898
  """
  @spec calculate_fuel(weight :: integer(), path :: [{action :: :land | :launch, celestial_body :: bitstring()}]) :: integer()
  def calculate_fuel(weight, path) do
    path
    |> Enum.reverse()
    |> Enum.reduce(weight, fn path, acc -> calculate_weight(acc, path) end)
    |> Kernel.-(weight)
  end

  @doc """
  Guard to check if the weight is either 0 or below it, to stop the recursive function.
  """
  defguard illegal_weight(weight) when weight <= 0

  @doc """
  Wrapper command which calculated weight whether the action is of launching or landing.

  ## Examples

    iex> NasaBtt.Servers.FuelCalcullator.calculate_weight(28801, {:land, "earth"})
    13447 + 28801

    iex> NasaBtt.Servers.FuelCalcullator.calculate_weight(42248, {:launch, "earth"})
    71419
  """
  def calculate_weight(weight, _) when illegal_weight(weight) do
    0
  end

  # For when landing
  def calculate_weight(weight, {:land, location} = path) do
    gravity = Gravitas.find(location)

    calculated = (weight * gravity * 0.033 - 42) |> trunc()

    weight + calculate_weight(calculated, path)
  end

  # For when launching
  def calculate_weight(weight, {:launch, location} = path) do
    gravity = Gravitas.find(location)

    calculated = (weight * gravity * 0.042 - 33) |> trunc()

    weight + calculate_weight(calculated, path)
  end
end
