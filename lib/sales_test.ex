defmodule SalesTest do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: SalesTest.Registry},
      # Product.ProductCache?,
      SalesTest.SaleSupervisor
    ]

    :ets.new(:sales_table, [:public, :named_table])

    opts = [strategy: :one_for_one, name: SalesTest.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
