defmodule ExCoin.Blockchain.Output do
  @moduledoc """
  Defines a basic transfer operation

  ```
  %Output{
    id: "id of output",
    tx_id: "id of transaction",
    previous_id: "id of input",
    senderKey: "public key of transaction issuer",
    recipient: "address of the recipient",
    amount: 100_000,
    fee: 10 # fee for miners
  }
  ```
  """

  defstruct [:id, :tx_id, :previous_id, :senderKey, :recipient, :amount, :fee]

  @type t :: %__MODULE__{
    id: String.t,
    tx_id: String.t,
    previous_id: String.t,
    senderKey: String.t,
    recipient: String.t,
    amount: Integer.t,
    fee: Integer.t
  }
end
