defmodule NasaBtt.Application do
  @behaviour Application
  
  def start(_, _) do
    if Application.get_env(:nasa_btt, :env) == :test do
      {:ok, self()}
    else
      Burrito.Util.Args.argv()
      |> NasaBtt.main()
    end
  end
  
  def stop(_) do
    :ok
  end
end