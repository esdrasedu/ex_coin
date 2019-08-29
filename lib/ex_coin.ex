defmodule ExCoin do
  use Application
  @moduledoc """
  Documentation for ExCoin.
  """

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(ExCoin.Blockchain.DB, [])
    ]

    opts = [strategy: :one_for_one, name: Grooty.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
