defmodule ExCoin.Blockchain.DB do
  use GenServer

  alias ExCoin.Blockchain.Transaction

  def init(%{database: database}) do
    {:ok, %{database: database}}
  end

  def start_link() do
    [name: name] = Application.get_env(:ex_coin, __MODULE__)
    {:ok, database} = Exleveldb.open(name)
    GenServer.start_link(__MODULE__, %{database: database}, [name: __MODULE__])
  end

  def handle_call({:get, id}, _from, %{database: database}) when is_bitstring(id) do
    result = Exleveldb.get(database, id);
    {:reply, result, %{database: database}}
  end

  def handle_cast({:put, id, transation}, %{database: database}) do
    :ok = Exleveldb.put(database, id, transation);
    {:noreply, %{database: database}}
  end

  @spec get(binary) :: Transaction.t | :not_found
  def get(id) when is_bitstring(id) do
    __MODULE__
    |> GenServer.call({:get, id})
    |> case do
         error -> error
    end
  end

  @spec put(Transaction.t) :: :ok | {:error, binary}
  def put(transation) do
    transation_json = Poison.encode(transation)
    GenServer.cast(__MODULE__, {:put, transation.id, transation_json})
  end
end
