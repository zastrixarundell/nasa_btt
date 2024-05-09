defmodule NasaBtt.Servers.FuelCalcullatorTest do
  
  alias NasaBtt.Servers.FuelCalcullator, as: Calcullator
  
  use ExUnit.Case
  doctest Calcullator
  
  describe "Direct Math Operations" do
    test "landing on earth" do
      assert Calcullator.landing_weight(28801, 9.807) == 42248
    end
    
    test "Apollo11 test suite" do
      shuttle_weight = 28801

      all_fuel =
        shuttle_weight
        |> Calcullator.landing_weight(9.807)
        |> Calcullator.launch_weight(1.62)
        |> Calcullator.landing_weight(1.62)
        |> Calcullator.launch_weight(9.807)
        # |> then(fn weight -> weight - shuttle_weight end)
        |> Kernel.-(shuttle_weight)
        
      assert all_fuel == 51898
    end
    
    test "Mission on Mars" do
      shuttle_weight = 14606

      all_fuel =
        shuttle_weight
        |> Calcullator.landing_weight(9.807)
        |> Calcullator.launch_weight(3.711)
        |> Calcullator.landing_weight(3.711)
        |> Calcullator.launch_weight(9.807)
        # |> then(fn weight -> weight - shuttle_weight end)
        |> Kernel.-(shuttle_weight)
        
      assert all_fuel == 33388
    end
    
    test "Passenger ship" do
      shuttle_weight = 75432

      all_fuel =
        shuttle_weight
        |> Calcullator.landing_weight(9.807)
        |> Calcullator.launch_weight(3.711)
        |> Calcullator.landing_weight(3.711)
        |> Calcullator.launch_weight(1.62)
        |> Calcullator.landing_weight(1.62)
        |> Calcullator.launch_weight(9.807)
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
  end
end
