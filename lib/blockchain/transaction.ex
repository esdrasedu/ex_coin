defmodule ExCoin.Blockchain.Transaction do
  @moduledoc """
  Defines a transaction struct and related functions

  A transaction define an atomic **ledger** state modification

  Simple implementation that only allows transfer. Defined by

  ```
  %Transaction{
    id: "",
    outputs: [%Output{}],
    timestamp: {1509, 931186, 658718},
    public_key: "",
    signatures: [""] # signed transaction hash
  }
  ```
  """

  defstruct [:id, :outputs, :timestamp, :public_key, :signatures]

  alias ExCoin.Blockchain.Output

  @type t :: %__MODULE__{
    id: String.t,
    outputs: [Output.t],
    timestamp: {Integer.t, Integer.t, Integer.t},
    public_key: String.t,
    signatures: [String.t]
  }
end
