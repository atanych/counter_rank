defmodule CounterRank.MyImpl do
  @behaviour CounterRank.API
  use Agent

  @moduledoc """
  CounterRank API.
  """

  @typedoc "Counter name/key"
  @type counter :: atom

  def start_link(_) do
    Agent.start_link(fn -> {%{}, %{}, 0} end, name: __MODULE__)
  end

  @doc """
  Increments the given `counter` value by one.

  If `counter` doesn't exist, the value is initialized in `1`.

  Keep in mind every time a counter is incremented the leaders or first place
  may change as well as the ranking, meaning, if a counter is incremented or
  changes, the leaders and ranking changes too.

  Expected worst case complexity: O(log2n)
  Best case complexity: O(1)

  ## Examples

      iex> MyImpl.incr(:my_counter)
      1

      iex> MyImpl.incr(:my_counter)
      2
  """
  @callback incr(counter) :: integer
  def incr(counter) do
    Agent.update(__MODULE__, fn {value_by_counter, counters_by_value, max} ->
      value = Map.get(value_by_counter, counter, 0) + 1

      {Map.put(value_by_counter, counter, value),
       update_counters_by_value(counters_by_value, value, counter), update_max(max, value)}
    end)

    Agent.get(__MODULE__, fn {value_by_counter, _, _} -> Map.get(value_by_counter, counter) end)
  end

  def update_counters_by_value(counters_by_value, value, counter) do
    old_value = value - 1

    counters_by_value =
      case old_value > 0 do
        true ->
          counter_list = Map.get(counters_by_value, old_value, []) -- [counter]

          if Enum.empty?(counter_list) do
            Map.delete(counters_by_value, old_value)
          else
            Map.put(
              counters_by_value,
              old_value,
              Map.get(counters_by_value, old_value) -- [counter]
            )
          end

        false ->
          counters_by_value
      end

    Map.put(counters_by_value, value, Map.get(counters_by_value, value, []) ++ [counter])
  end

  def update_max(max, value) when max < value, do: value
  def update_max(max, value), do: max

  @doc """
  Returns the rank leader(s).

  The returned value is a list with the counters sharing the first place.

  Expected worst case complexity: O(log2n)
  Best case complexity: O(1)

  ## Examples


      iex> Enum.each(1..3, &MyImpl.incr(:a))
      :ok

      iex> MyImpl.leaders()
      [:a]
  """
  @callback leaders :: [counter]
  def leaders do
    Agent.get(__MODULE__, fn {_, counters_by_value, max} ->
      Map.get(counters_by_value, max) || []
    end)
  end

  @doc """
  Returns the ranking list of counters (top-down).

  The list is returned in descending order (top-down), showing the list of
  counters sharing that position and the corresponding value.

  Expected worst case complexity: O(n)

  ## Examples

      iex> MyImpl.rank()
      [{5, [:a]}, {3, [:b]}, {2, [:c]}, {1, [:d]}]
  """
  @callback rank :: [{counting_value :: integer, [counter]}]
  def rank do
    Agent.get(__MODULE__, fn {_, counters_by_value, max} ->
      counters_by_value |> Map.to_list() |> Enum.sort_by(fn {key, _} -> -key end)
    end)
  end
end
