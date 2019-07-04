defmodule MyImplTest do
  use ExUnit.Case
  doctest CounterRank

  describe ".update_counters_by_value" do
    test "existing counter" do
      assert CounterRank.MyImpl.update_counters_by_value(%{1 => [:c, :d], 2 => [:v]}, 2, :c) == %{
               1 => [:d],
               2 => [:v, :c]
             }
    end

    test "not existing counter" do
      assert CounterRank.MyImpl.update_counters_by_value(%{1 => [:c, :d]}, 1, :e) == %{
               1 => [:c, :d, :e]
             }
    end

    test "the value without counters" do
      assert CounterRank.MyImpl.update_counters_by_value(%{1 => [:c], 3 => [:v]}, 2, :c) == %{
               3 => [:v],
               2 => [:c]
             }
    end
  end

  describe ".update_max" do
    test "max less than value" do
      assert CounterRank.MyImpl.update_max(5, 6) == 6
    end

    test "max more than value" do
      assert CounterRank.MyImpl.update_max(7, 6) == 7
    end
  end
end
