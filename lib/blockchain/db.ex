defmodule ExCoin.Blockchain.DB do
  use GenServer

  alias ExCoin.Blockchain.{Block, Transaction, Output}

  def init(%{database: database}) do
    {:ok, %{database: database}}
  end

  def start_link() do
    [name: name] = Application.get_env(:ex_coin, __MODULE__)
    {:ok, database} = Exleveldb.open(name)
    GenServer.start_link(__MODULE__, %{database: database}, [name: __MODULE__])
  end

  def handle_call({:get, id}, _from, %{database: database}) when is_bitstring(id) do
    result = Exleveldb.get(database, id)
    |> decode()

    {:reply, result, %{database: database}}
  end

  defp decode(:not_found), do: {:error, "id not found on database"}
  defp decode({:ok, json}) do
    json
    |> Jason.decode([keys: :atoms!])
    |> case do
         {:ok, %{tx_id: _tx_id} = output} -> {:ok, struct(Output, output)}
         {:ok, %{outputs: _outputs} = transaction} -> {:ok, struct(Transaction, transaction)}
         {:ok, %{hash: _block} = block} -> {:ok, struct(Block, block)}
         _error -> {:error, "corrupted database"}
       end
  end

  def handle_cast({:put, id, data}, %{database: database}) do
    :ok = Exleveldb.put(database, id, data);
    {:noreply, %{database: database}}
  end

  @spec find(binary | integer) :: {:ok, Transaction.t} | {:ok, Output.t} | {:error, binary}
  def find(id) when is_bitstring(id) or is_integer(id) do
    __MODULE__
    |> GenServer.call({:get, id})
    |> case do
         error -> error
    end
  end

  @spec save(Block.t | Transaction.t | Output.t) :: :ok | {:error, binary}
  def save(data) do
    {:ok, json} = data
    |> Map.from_struct()
    |> Jason.encode()

    index = data
    |> case do
         %{id: id} -> id
         %{index: index} -> index
       end
    GenServer.cast(__MODULE__, {:put, index, json})
  end
end
