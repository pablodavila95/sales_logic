defmodule SalesTest.SaleServer do
  use GenServer
  require Logger

  def start_link(sale_id) do
    GenServer.start_link(
      __MODULE__,
      {sale_id},
      name: via_tuple(sale_id)
    )
  end

  def summary(sale_id) do
    GenServer.call(via_tuple(sale_id), :summary)
  end

  def change_status(sale_id, status) do
    GenServer.call(via_tuple(sale_id), {:change_status, status})
  end

  def via_tuple(sale_id) do
    {:via, Registry, {SalesTest.Registry, sale_id}}
  end

  def sale_pid(sale_id) do
    sale_id
    |> via_tuple()
    |> GenServer.whereis()
  end

  def set_details(sale_id) do
    # Call database and fill the map with the details
    GenServer.call(via_tuple(sale_id), :set_details)
  end

  # Server Callbacks

  def init({sale_id}) do
    sale =
      case :ets.lookup(:sales_table, sale_id) do
        [] ->
          sale = SalesTest.Sale.new(sale_id)
          :ets.insert(:sales_table, {sale_id, sale})
          sale

        [{^sale_id, sale}] ->
          sale
      end

    Logger.info("Spawned a new sale with the id '#{sale_id}'.")
    {:ok, sale}
  end

  def handle_call(:summary, _from, sale) do
    {:reply, summarize(sale), sale}
  end

  def handle_call({:change_status, status}, _from, sale) do
    new_sale = SalesTest.Sale.set_status(sale, status)

    :ets.insert(:sales_table, {my_sale_name(), new_sale})

    {:reply, summarize(new_sale), new_sale}
  end

  def handle_call(:set_details, _from, sale) do
    new_sale = SalesTest.Sale.set_details(sale)
    :ets.insert(:sales_table, {my_sale_name(), new_sale})

    {:reply, summarize(new_sale), new_sale}
  end

  def summarize(sale) do
    %{
      transaction_id: sale.transaction_id,
      status: sale.status,
      buyer: sale.buyer,
      seller: sale.seller,
      amount: sale.amount,
    }
  end

  def terminate({:shutdown}, _sale) do
    :ets.delete(:sales_table, my_sale_name())
    :ok
  end

  def terminate(_reason, _game) do
    :ok
  end

  def my_sale_name do
    Registry.keys(SalesTest.Registry, self()) |> List.first()
  end
end
