defmodule Animedl.Parallel do
  @moduledoc """
  Parallel map that limits to specified process count.
  https://jmilet.github.io/processes/elixir/erlang/2016/04/04/limited-pmap.html
  """

  def run(col, workers, fun) do
    run(col, fun, workers, 0, [])
  end

  defp run([h | t], fun, workers, n, res) when n < workers do
    me = self()

    spawn_link(fn ->
      send(me, {h, fun.(h)})
    end)

    run(t, fun, workers, n + 1, res)
  end

  defp run([], fun, workers, n, res) when n > 0 do
    receive do
      value -> run([], fun, workers, n - 1, [value | res])
    end
  end

  defp run([], _fun, _workers, _n, res) do
    res
  end

  defp run(col, fun, workers, n, res) do
    receive do
      value -> run(col, fun, workers, n - 1, [value | res])
    end
  end
end
