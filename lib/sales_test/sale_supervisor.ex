defmodule SalesTest.SaleSupervisor do
  use DynamicSupervisor

  alias SalesTest.SaleServer

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_sale(sale_id) do
    child_spec = %{
      id: SaleServer,
      start: {SaleServer, :start_link, [sale_id]}
    }
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @spec end_sale(any) :: :ok | {:error, :not_found}
  def end_sale(sale_id) do
    :ets.delete(:sales_table, sale_id)

    child_pid = SaleServer.sale_pid(sale_id)
    DynamicSupervisor.terminate_child(__MODULE__, child_pid)
  end
end
