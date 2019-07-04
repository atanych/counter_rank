defmodule CounterRank.API do
  @moduledoc """
  CounterRank API.
  """

  @typedoc "Counter name/key"
  @type counter :: atom

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
end
