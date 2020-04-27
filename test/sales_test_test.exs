defmodule SalesTestTest do
  use ExUnit.Case
  doctest SalesTest

  test "greets the world" do
    assert SalesTest.hello() == :world
  end
end
