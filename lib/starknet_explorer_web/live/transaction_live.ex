defmodule StarknetExplorerWeb.TransactionLive do
  use StarknetExplorerWeb, :live_view
  alias StarknetExplorer.Rpc
  alias StarknetExplorerWeb.Utils

  defp transaction_header(assigns) do
    ~H"""
    <div class="flex flex-col md:flex-row justify-between">
      <div class="flex gap-2 items-baseline">
        <h2>Transaction</h2>
        <div class="font-semibold">
          <%= @transaction["transaction_hash"] %>
        </div>
      </div>
    </div>
    <div class="flex flex-col md:flex-row gap-5 mt-8 mb-10 md:mb-0">
      <div
        class={"btn border-b pb-3 px-3 transition-all duration-300 #{if assigns.transaction_view == "overview", do: "border-b-se-blue", else: "border-b-transparent"}"}
        phx-click="select-view"
        ,
        phx-value-view="overview"
      >
        Overview
      </div>
      <div
        class={"btn border-b pb-3 px-3 transition-all duration-300 #{if assigns.transaction_view == "events", do: "border-b-se-blue", else: "border-b-transparent"}"}
        phx-click="select-view"
        ,
        phx-value-view="events"
      >
        Events
      </div>
      <div
        class={"btn border-b pb-3 px-3 transition-all duration-300 #{if assigns.transaction_view == "message_logs", do: "border-b-se-blue", else: "border-b-transparent"}"}
        phx-click="select-view"
        ,
        phx-value-view="message_logs"
      >
        Message Logs
      </div>
      <div
        class={"btn border-b pb-3 px-3 transition-all duration-300 #{if assigns.transaction_view == "internal_calls", do: "border-b-se-blue", else: "border-b-transparent"}"}
        phx-click="select-view"
        ,
        phx-value-view="internal_calls"
      >
        Internal Calls
      </div>
    </div>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-7xl mx-auto bg-container p-4 md:p-6 rounded-md">
      <%= transaction_header(assigns) %>
      <%= render_info(assigns) %>
    </div>
    """
  end

  def render_info(%{transaction: nil, transaction_receipt: nil} = assigns) do
    ~H"""
    <%= transaction_header(assigns) %>
    """
  end

  # TODO:
  # Do not hardcode the following:
  # Identifier
  # Name
  # Age
  def render_info(%{transaction_view: "events"} = assigns) do
    ~H"""
    <div class="hidden md:grid grid-cols-6 gap-10 px-3 pt-5 pb-3 font-semibold border-t border-t-gray-700">
      <div>Identifier</div>
      <div>Block Number</div>
      <div>Transaction Hash</div>
      <div>Name</div>
      <div>From Address</div>
      <div>Age</div>
    </div>
    <%= for _signature <- @transaction_receipt["events"] do %>
      <div class="grid md:grid-cols-6 gap-2 md:gap-10 px-3 pt-3 mb-3 border-t border-t-gray-700">
        <div class="list-h">Identifier</div>
        <div
          class="copy-container flex gap-4 items-center"
          id={"tsx-overview-identifier-#{@transaction_receipt["block_number"]}"}
          phx-hook="Copy"
        >
          <div class="relative">
            <div>
              <%= "0x008e571d599345e12730f53df66cf74bea8ad238d68844b71ebadb567eae7a1d_4"
              |> Utils.shorten_block_hash() %>
            </div>
            <div class="absolute top-1/2 -right-6 tranform -translate-y-1/2">
              <div class="relative">
                <img
                  class="copy-btn copy-text w-4 h-4"
                  src={~p"/images/copy.svg"}
                  data-text="0x008e571d599345e12730f53df66cf74bea8ad238d68844b71ebadb567eae7a1d_4"
                />
                <img
                  class="copy-check absolute top-0 left-0 w-4 h-4 opacity-0 pointer-events-none"
                  src={~p"/images/check-square.svg"}
                />
              </div>
            </div>
          </div>
        </div>
        <div class="list-h">Block Number</div>
        <div><span class="blue-label"><%= @transaction_receipt["block_number"] %></span></div>
        <div class="list-h">Transaction Hash</div>
        <div>
          <div
            class="copy-container flex gap-4 items-center"
            id={"tsx-overview-hash-#{@transaction["transaction_hash"]}"}
            phx-hook="Copy"
          >
            <div class="relative">
              <div>
                <%= @transaction["transaction_hash"] |> Utils.shorten_block_hash() %>
              </div>
              <div class="absolute top-1/2 -right-6 tranform -translate-y-1/2">
                <div class="relative">
                  <img
                    class="copy-btn copy-text w-4 h-4"
                    src={~p"/images/copy.svg"}
                    data-text={@transaction["transaction_hash"]}
                  />
                  <img
                    class="copy-check absolute top-0 left-0 w-4 h-4 opacity-0 pointer-events-none"
                    src={~p"/images/check-square.svg"}
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="list-h">Name</div>
        <div><span class="lilac-label">Transfer</span></div>
        <div class="list-h">From Address</div>
        <div>
          <div
            class="copy-container flex gap-4 items-center"
            id={"tsx-overview-sender-#{@transaction["sender_address"]}"}
            phx-hook="Copy"
          >
            <div class="relative">
              <div>
                <%= @transaction["sender_address"] |> Utils.shorten_block_hash() %>
              </div>
              <div class="absolute top-1/2 -right-6 tranform -translate-y-1/2">
                <div class="relative">
                  <img
                    class="copy-btn copy-text w-4 h-4"
                    src={~p"/images/copy.svg"}
                    data-text={@transaction["sender_address"]}
                  />
                  <img
                    class="copy-check absolute top-0 left-0 w-4 h-4 opacity-0 pointer-events-none"
                    src={~p"/images/check-square.svg"}
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="list-h">Age</div>
        <div>1h</div>
      </div>
    <% end %>
    """
  end

  # TODO:
  # Everything here is hardcoded.
  # I think this information comes from the block.
  def render_info(%{transaction_view: "message_logs"} = assigns) do
    ~H"""
    <div class="hidden lg:grid grid-cols-8 gap-2 px-3 pt-5 pb-3 font-semibold border-t border-t-gray-700">
      <div>Identifier</div>
      <div>Message Hash</div>
      <div>Direction</div>
      <div>Type</div>
      <div>From Address</div>
      <div>To Address</div>
      <div>Transaction Hash</div>
      <div>Age</div>
    </div>
    <div class="grid lg:grid-cols-8 gap-2 px-3 pt-3 mb-3 border-t border-t-gray-700">
      <div class="font-ibm-plex text-sm pt-2 text-gray-400 lg:hidden">Identifier</div>
      <div>
        <%= "0x008e571d599345e12730f53df66cf74bea8ad238d68844b71ebadb567eae7a1d"
        |> Utils.shorten_block_hash() %>
      </div>
      <div class="font-ibm-plex text-sm pt-2 text-gray-400 lg:hidden">Message Hash</div>
      <div>
        <%= "0x008e571d599345e12730f53df66cf74bea8ad238d68844b71ebadb567eae7a1d"
        |> Utils.shorten_block_hash() %>
      </div>
      <div class="font-ibm-plex text-sm pt-2 text-gray-400 lg:hidden">Direction</div>
      <div><span class="green-label">L2</span>><span class="blue-label">L1</span></div>
      <div class="font-ibm-plex text-sm pt-2 text-gray-400 lg:hidden">Type</div>
      <div>Sent On L2</div>
      <div class="font-ibm-plex text-sm pt-2 text-gray-400 lg:hidden">From Address</div>
      <div>
        <%= "0x008e571d599345e12730f53df66cf74bea8ad238d68844b71ebadb567eae7a1d"
        |> Utils.shorten_block_hash() %>
      </div>
      <div class="font-ibm-plex text-sm pt-2 text-gray-400 lg:hidden">To Address</div>
      <div>
        <%= "0x008e571d599345e12730f53df66cf74bea8ad238d68844b71ebadb567eae7a1d"
        |> Utils.shorten_block_hash() %>
      </div>
      <div class="font-ibm-plex text-sm pt-2 text-gray-400 lg:hidden">Transaction Hash</div>
      <div>
        <%= "0x008e571d599345e12730f53df66cf74bea8ad238d68844b71ebadb567eae7a1d"
        |> Utils.shorten_block_hash() %>
      </div>
      <div class="font-ibm-plex text-sm pt-2 text-gray-400 lg:hidden">Age</div>
      <div>9min</div>
    </div>
    """
  end

  def render_info(%{transaction_view: "internal_calls"} = assigns) do
    ~H"""
    <div class="hidden lg:grid grid-cols-5 gap-10 px-3 pt-5 pb-3 font-semibold border-t border-t-gray-700">
      <div>Identifier</div>
      <div>Transaction Hash</div>
      <div>Type</div>
      <div>Name</div>
      <div>Contract Address</div>
    </div>
    <div class="grid lg:grid-cols-5 gap-2 lg:gap-10 px-3 pt-3 mb-3 border-t border-t-gray-700">
      <div class="font-ibm-plex text-sm pt-2 text-gray-400 lg:hidden">Identifier</div>
      <div class="text-hover-blue">
        <%= "0x008e571d599345e12730f53df66cf74bea8ad238d68844b71ebadb567eae7a1d"
        |> Utils.shorten_block_hash() %>
      </div>
      <div class="font-ibm-plex text-sm pt-2 text-gray-400 lg:hidden">Transaction Hash</div>
      <div>
        <%= "0x008e571d599345e12730f53df66cf74bea8ad238d68844b71ebadb567eae7a1d"
        |> Utils.shorten_block_hash() %>
      </div>
      <div class="font-ibm-plex text-sm pt-2 text-gray-400 lg:hidden">Type</div>
      <div><span class="lilac-label">Call</span></div>
      <div class="font-ibm-plex text-sm pt-2 text-gray-400 lg:hidden">Name</div>
      <div><span class="green-label">__execute__</span></div>
      <div class="font-ibm-plex text-sm pt-2 text-gray-400 lg:hidden">Contract Address</div>
      <div>
        <%= "0x008e571d599345e12730f53df66cf74bea8ad238d68844b71ebadb567eae7a1d"
        |> Utils.shorten_block_hash() %>
      </div>
    </div>
    """
  end

  # TODO:
  # Do not hardcode the following:
  # Call data
  # Signatures
  # Execution resources
  def render_info(%{transaction_view: "overview"} = assigns) do
    ~H"""
    <div class="block-overview">
      <div class="block-label">Transaction Hash</div>
      <div class="col-span-3 break-all">
        <%= @transaction["transaction_hash"] |> Utils.shorten_block_hash() %>
      </div>
    </div>
    <div class="block-overview">
      <div class="block-label">Transaction Type</div>
      <div class="col-span-3">
        <span class={"#{if @transaction["type"] == "INVOKE", do: "violet-label", else: "lilac-label"}"}>
          <%= @transaction["type"] %>
        </span>
      </div>
    </div>
    <div class="block-overview">
      <div class="block-label">Status</div>
      <div class="col-span-3">
        <span class={"#{if @transaction_receipt["status"] == "ACCEPTED_ON_L2", do: "green-label"} #{if @transaction_receipt["status"] == "ACCEPTED_ON_L1", do: "blue-label"} #{if @transaction_receipt["status"] == "PENDING", do: "pink-label"}"}>
          <%= @transaction_receipt["status"] %>
        </span>
      </div>
    </div>
    <div class="block-overview">
      <div class="block-label">Block Number</div>
      <div class="col-span-3">
        <span class="blue-label"><%= @transaction_receipt["block_number"] %></span>
      </div>
    </div>
    <div class="block-overview">
      <div class="block-label">Block Hash</div>
      <div class="col-span-3 text-hover-blue break-all">
        <%= @transaction_receipt["block_hash"] |> Utils.shorten_block_hash() %>
      </div>
    </div>
    <div class="block-overview">
      <div class="block-label">Sender Address</div>
      <div class="col-span-3 break-all">
        <%= @transaction["sender_address"] |> Utils.shorten_block_hash() %>
      </div>
    </div>
    <div class="block-overview">
      <div class="block-label">Actual Fee</div>
      <div class="col-span-3"><%= @transaction_receipt["actual_fee"] %></div>
    </div>
    <div class="block-overview">
      <div class="block-label">Max Fee</div>
      <div class="col-span-3">
        <span class="bg-se-cash-green/10 text-se-cash-green rounded-full px-4 py-1">
          <%= @transaction["max_fee"] %>
        </span>
      </div>
    </div>
    <div class="block-overview">
      <div class="block-label">Nonce</div>
      <div class="col-span-3"><%= @transaction["nonce"] %></div>
    </div>
    <div class="block-overview">
      <div class="block-label">Input Data</div>
      <div class="col-span-full">
        <div class="bg-black/20 p-5 mt-5">
          call <span class="text-se-violet">approve</span>(<span class="text-blue-400">spender</span>, <span class="text-blue-400">amount</span>)
          <span class="text-blue-400">-></span> <%= Utils.shorten_block_hash(
            "0x0219209e083275171774dab1df80982e9df2096516f06319c5c6d71ae0a8480c"
          ) %>
        </div>
        <div class="bg-black/10 lg:p-5">
          <div class="hidden md:grid grid-cols-3 px-5 text-gray-400">
            <div>Input</div>
            <div>Type</div>
            <div>Value</div>
          </div>
          <div class="grid md:grid-cols-3 px-5 border-t border-t-gray-700 mt-3 pt-2">
            <div class="list-h">Input</div>
            <div>spender</div>
            <div class="list-h">Type</div>
            <div>felt</div>
            <div class="list-h">Value</div>
            <div class="break-all">
              <%= Utils.shorten_block_hash(
                "0x11cd02208d6ed241d3fc0dba144f09b70be03003c32e56de2d19aea99b0ca76"
              ) %>
            </div>
          </div>
          <div class="grid md:grid-cols-3 px-5 border-t border-t-gray-700 mt-3 pt-2">
            <div class="list-h">Input</div>
            <div>token_id</div>
            <div class="list-h">Type</div>
            <div>felt</div>
            <div class="list-h">Value</div>
            <div>1580969</div>
          </div>
        </div>
        <div class="bg-black/20 p-5 mt-5">
          call <span class="text-se-violet">swap</span>(<span class="text-blue-400">pool_id</span>, <span class="text-blue-400">token_from_addr</span>, <span class="text-blue-400">amount_from</span>, <span class="text-blue-400">amount_to_min</span>)
          <span class="text-blue-400">-></span>
          <%= "0x015543c3708653cda9d418b4ccd3be11368e40636c10c44b18cfe756b6d88b29"
          |> Utils.shorten_block_hash() %>
        </div>
        <div class="bg-black/10 lg:p-5">
          <div class="hidden md:grid grid-cols-3 px-5 text-gray-400">
            <div>Input</div>
            <div>Type</div>
            <div>Value</div>
          </div>
          <div class="grid md:grid-cols-3 px-5 border-t border-t-gray-700 mt-3 pt-2">
            <div class="list-h">Input</div>
            <div>pool_id</div>
            <div class="list-h">Type</div>
            <div>felt</div>
            <div class="list-h">Value</div>
            <div class="break-all">
              <%= "0x42b8f0484674ca266ac5d08e4ac6a3fe65bd3129795def2dca5c34ecc5f96d2"
              |> Utils.shorten_block_hash() %>
            </div>
          </div>
          <div class="grid md:grid-cols-3 px-5 border-t border-t-gray-700 mt-3 pt-2">
            <div class="list-h">Input</div>
            <div>token_from_addr</div>
            <div class="list-h">Type</div>
            <div>felt</div>
            <div class="list-h">Value</div>
            <div class="break-all">
              <%= "0x42b8f0484674ca266ac5d08e4ac6a3fe65bd3129795def2dca5c34ecc5f96d2"
              |> Utils.shorten_block_hash() %>
            </div>
          </div>
          <div class="grid md:grid-cols-3 px-5 border-t border-t-gray-700 mt-3 pt-2">
            <div class="list-h">Input</div>
            <div>amount_from</div>
            <div class="list-h">Type</div>
            <div>Uint256</div>
            <div class="list-h">Value</div>
            <div><%= "71587356859985694" |> Utils.shorten_block_hash() %></div>
          </div>
          <div class="grid md:grid-cols-3 px-5 border-t border-t-gray-700 mt-3 pt-2">
            <div class="list-h">Input</div>
            <div>amount_to_min</div>
            <div class="list-h">Type</div>
            <div>Uint256</div>
            <div class="list-h">Value</div>
            <div><%= "80225122454772041" |> Utils.shorten_block_hash() %></div>
          </div>
        </div>
      </div>
    </div>
    <div class="block-overview">
      <div class="col-span-full">Signature</div>
      <div class="col-span-full bg-black/10 lg:p-5">
        <div class="grid grid-cols-3 lg:grid-cols-8 gap-5 px-5 text-gray-400">
          <div>Index</div>
          <div class="col-span-2">Value</div>
        </div>
        <%= for {index, signature} <- Enum.with_index(@transaction["signature"]) do %>
          <div class="grid grid-cols-3 lg:grid-cols-8 gap-5 px-5 border-t border-t-gray-700 pt-4 mt-4">
            <div class="break-all"><%= signature %></div>
            <div class="break-all col-span-2"><%= index |> Utils.shorten_block_hash() %></div>
          </div>
        <% end %>
      </div>
    </div>
    <div class="block-overview">
      <div class="col-span-full mb-10 md:mb-0">Execution Resources</div>
      <div class="flex flex-col md:flex-row gap-5">
        <div class="flex flex-col justify-center items-center gap-2">
          <span class="blue-label">STEPS</span> 5083
        </div>
        <div class="flex flex-col justify-center items-center gap-2">
          <span class="green-label">MEMORY</span> 224
        </div>
        <div class="flex flex-col justify-center items-center gap-2">
          <span class="pink-label">PEDERSEN_BUILTIN</span> 21
        </div>
        <div class="flex flex-col justify-center items-center gap-2">
          <span class="violet-label">RANGE_CHECK_BUILTIN</span> 224
        </div>
      </div>
    </div>
    """
  end

  def mount(%{"transaction_hash" => transaction_hash}, _session, socket) do
    Process.send(self(), :load_transaction, [])

    assigns = [
      transaction_hash: transaction_hash,
      transaction: nil,
      transaction_receipt: nil,
      transaction_view: "overview"
    ]

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_info(
        :load_transaction,
        %{assigns: %{transaction_hash: transaction_hash}} = socket
      ) do
    {:ok, transaction} = Rpc.get_transaction(transaction_hash)

    {:ok, transaction_receipt} = Rpc.get_transaction_receipt(transaction_hash)

    assigns = [
      transaction: transaction,
      transaction_receipt: transaction_receipt,
      transaction_hash: socket.assigns.transaction_hash,
      transaction_view: socket.assigns.transaction_view
    ]

    socket = assign(socket, assigns)
    {:noreply, socket}
  end

  def handle_event("select-view", %{"view" => view}, socket) do
    socket = assign(socket, :transaction_view, view)
    {:noreply, socket}
  end
end
