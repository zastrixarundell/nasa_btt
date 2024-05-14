defmodule NasaBtt do
  
  @behaviour Application

  alias NasaBtt.Servers.FuelCalcullator
  alias NasaBtt.Parser

  def start(_, _) do
    with [initial_weight, locations] <- Burrito.Util.Args.get_arguments(),
         {:ok, weight} <- Parser.parse_weight(initial_weight),
         {:ok, path} <- Parser.parse_locations(locations),
         {:ok, pid} = Supervisor.start_link([FuelCalcullator], strategy: :one_for_one) do

      fuel_pid =
        Supervisor.which_children(pid)
        |> List.first()
        |> elem(1)

      FuelCalcullator.request_fuel(weight, path, fuel_pid)

      receive do
        {:calculated_weight, weight, fuel_weight} ->
          # Assertion: Ensure that the completion message is received
          IO.puts("path: #{Parser.sanitize_path(path)}")
          IO.puts("weight of equipment: #{weight} kg")
          IO.puts("weight of fuel: #{fuel_weight} kg")
      after
        5000 ->
          # Timeout: Fail the test if the message is not received within 5 seconds
          IO.puts(:stderr, "Message not received!")
      end
    else
    _ ->
      IO.puts(
        :stderr,
        "The weight or location is not correct. Please check the command usage!"
      )

      System.halt(1)
    end

    System.halt(0)
  end

  def stop(_) do
    :ok
  end

end
