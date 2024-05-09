defmodule NasaBtt.Servers.FuelCalcullator do
  use GenServer
  
  alias NasaBtt.Gravitas
  
  # Client-side
  
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end
  
  @doc """
  Send a request to get the fuel information. Eventually a message will be sent to the calling process with
  the following format: `{:calcualted_weight, weight, fuel_weight}`.
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
      fuel_weight = calculate_fuel(weight, path) - weight
      send(calling_pid, {:calcualted_weight, weight, fuel_weight})
    end)
    
    # A cosmic ray hit something so it's taking a bit of time!
    Process.sleep(50000)

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
    |> Enum.reduce(weight, &calculate_weight/2)
    |> Kernel.-(weight)
  end
  
  @doc """
  Wrapper command which calculated weight whether the action is of launching or landing.
  
  ## Examples
  
    iex> NasaBtt.Servers.FuelCalcullator.calculate_weight({:land, "earth"}, 28801)
    13447 + 28801
    
    iex> NasaBtt.Servers.FuelCalcullator.calculate_weight({:launch, "earth"}, 42248)
    71419
  """
  def calculate_weight({:land, location}, weight) do
    landing_weight(weight, Gravitas.find!(location))
  end
  
  def calculate_weight({:launch, location}, weight) do
    launch_weight(weight, Gravitas.find!(location))
  end
  
  @doc """
  Guard to check if the weight is either 0 or below it, to stop the recursive function.
  """
  defguard illegal_weight(weight) when weight <= 0

  @doc """
  Get the whole weight of the shuttle including the fuel which is used for landing
  
  ## Examples
  
    iex> NasaBtt.Servers.FuelCalcullator.landing_weight(28801, 9.807)
    13447 + 28801
  """
  @spec landing_weight(weight :: integer(), gravity :: float()) :: integer()
  def landing_weight(weight, gravity)
  
  def landing_weight(weight, _gravity) when illegal_weight(weight) do
    0
  end
  
  def landing_weight(weight, gravity) do
    calcualted = (weight * gravity * 0.033 - 42) |> trunc()
    
    weight + landing_weight(calcualted, gravity)
  end
  
  @doc """
  Similar to `landing_weight/2`, but just the inverse process.
  
  ## Examples
  
    iex> NasaBtt.Servers.FuelCalcullator.launch_weight(42248, 1.62)
    45249
  """
  def launch_weight(weight, _gravity) when illegal_weight(weight) do
    0
  end
  
  def launch_weight(weight, gravity) do
    calcualted = (weight * gravity * 0.042 - 33) |> trunc()
    
    weight + launch_weight(calcualted, gravity)
  end
end