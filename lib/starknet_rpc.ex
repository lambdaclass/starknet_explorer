defmodule StarknetExplorer.Rpc do
  plug Tesla.Middleware.BaseUrl, "https://starknet-mainnet.infura.io/v3/" <> Application.compile_env(:rpc, :api_key)
  plug Tesla.Middleware.JSON
end
