defmodule StarknetExplorer.BlockchainFetcher do
  use DynamicSupervisor

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def stop_child(pid) do
    DynamicSupervisor.terminate_child(__MODULE__, pid)
  end

  def init(_) do
    {:ok, %{}}
  end

  def fetch_in_range(args = %{start: start, finish: finish})
      when start >= finish and is_integer(start) and is_integer(finish) do
    spec =
      %{
        id: StarknetExplorer.BlockchainFetcher.Worker,
        start: {StarknetExplorer.BlockchainFetcher.Worker, :start_link, [args]}
      }

    {:ok, _fetcher} =
      DynamicSupervisor.start_child(
        __MODULE__,
        spec
      )
  end

  def fetch_in_range(_args) do
    {:error, "Error starting block fetcher, make sure that start >= finish}"}
  end

  def find_and_set_missing_fields() do
    spec =
      %{
        id: StarknetExplorer.BlockUpdater,
        start: {StarknetExplorer.BlockUpdater, :start_link, [%{}]}
      }

    {:ok, _} =
      DynamicSupervisor.start_child(
        __MODULE__,
        spec
      )
  end
end