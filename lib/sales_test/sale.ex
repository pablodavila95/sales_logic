defmodule SalesTest.Sale do
  defstruct transaction_id: nil, status: :initial, buyer: "", seller: "", amount: 0
  alias SalesTest.Sale

  def new(transaction) do
    %Sale{transaction_id: transaction, status: :initial}
  end

  def set_status(sale, :confirmed) do
    Map.put(sale, :status, :confirmed)
  end

  def set_status(sale, :scanned) do
    Map.put(sale, :status, :scanned)
  end

  def set_status(sale, :finished) do
    Map.put(sale, :status, :finished)
  end

  def set_status(_, _) do
    IO.puts("wrong status code or saleid")
  end

  def set_details(sale) do
    temp = %{buyer: "Pablo", seller: "Giadans", amount: 100}
    Map.merge(sale, temp)
  end

  def get_details() do #transactionID as parameter
    temp = %{buyer: "Pablo", seller: "Giadans", amount: 100}
    temp
  end
end
