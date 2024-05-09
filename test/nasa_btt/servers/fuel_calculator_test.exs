defmodule NasaBtt.Servers.FuelCalcullatorTest do
  
  alias NasaBtt.Servers.FuelCalcullator, as: Calcullator
  
  import ExUnit.CaptureIO
  
  use ExUnit.Case
  doctest Calcullator
  
  describe "Direct Math Operations" do
    test "Apollo11 test suite" do
      shuttle_weight = 28801

      all_fuel =
        shuttle_weight
        |> Calcullator.calculate_weight({:land, "earth"})
        |> Calcullator.calculate_weight({:launch, "moon"})
        |> Calcullator.calculate_weight({:land, "moon"})
        |> Calcullator.calculate_weight({:launch, "earth"})
        # |> then(fn weight -> weight - shuttle_weight end)
        |> Kernel.-(shuttle_weight)
        
      assert all_fuel == 51898
    end
    
    test "Mission on Mars" do
      shuttle_weight = 14606

      all_fuel =
        shuttle_weight
        |> Calcullator.calculate_weight({:land, "earth"})
        |> Calcullator.calculate_weight({:launch, "mars"})
        |> Calcullator.calculate_weight({:land, "mars"})
        |> Calcullator.calculate_weight({:launch, "earth"})
        # |> then(fn weight -> weight - shuttle_weight end)
        |> Kernel.-(shuttle_weight)
        
      assert all_fuel == 33388
    end
    
    test "Passenger ship" do
      shuttle_weight = 75432

      all_fuel =
        shuttle_weight
        |> Calcullator.calculate_weight({:land, "earth"})
        |> Calcullator.calculate_weight({:launch, "mars"})
        |> Calcullator.calculate_weight({:land, "mars"})
        |> Calcullator.calculate_weight({:launch, "moon"})
        |> Calcullator.calculate_weight({:land, "moon"})
        |> Calcullator.calculate_weight({:launch, "earth"})
        # |> then(fn weight -> weight - shuttle_weight end)
        |> Kernel.-(shuttle_weight)
        
      assert all_fuel == 212161
    end
  end
  
  describe "Path calculation" do
    test "Apollo11" do
      assert Calcullator.calculate_fuel(28801, [
        {:launch, "earth"},
        {:land, "moon"},
        {:launch, "moon"},
        {:land, "earth"},
      ]) == 51898
    end
    
    test "Mission on Mars" do
      assert Calcullator.calculate_fuel(14606, [
        {:launch, "earth"},
        {:land, "mars"},
        {:launch, "mars"},
        {:land, "earth"},
      ]) == 33388
    end
    
    test "passenger ship" do
      assert Calcullator.calculate_fuel(75432, [
        {:launch, "earth"},
        {:land, "moon"},
        {:launch, "moon"},
        {:land, "mars"},
        {:launch, "mars"},
        {:land, "earth"},
      ]) == 212161
    end
  end
  
  test "Async GenServer request" do
    {:ok, pid} = Calcullator.start_link([])
    
    Calcullator.request_fuel(28801, [
      {:launch, "earth"},
      {:land, "moon"},
      {:launch, "moon"},
      {:land, "earth"},
    ], pid)
    
    Process.sleep(100)
    
    assert_receive {:calcualted_weight, 28801, fuel_weight}, 5000
    
    assert fuel_weight == 51898 - 28801
  end
end
