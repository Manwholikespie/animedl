defmodule Mix.Tasks.Get do
  use Mix.Task

  def run(querytokens) do
    Application.ensure_all_started(:animedl)
    Animedl.create_dirs()

    querytokens
    |> Enum.join(" ")
    |> Animedl.search()
  end
end
