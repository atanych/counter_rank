defmodule CounterRank.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      CounterRank.MyImpl
    ]

    opts = [strategy: :one_for_one, name: CounterRank.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
