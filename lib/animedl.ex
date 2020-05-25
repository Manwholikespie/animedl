defmodule Animedl do
  @outdir Application.get_env(:animedl, :outdir)

  @spec search(String.t()) :: :ok
  def search(query) do
    query
    |> Animedl.Fetch.search()
    |> Animedl.Fetch.download_parallel()
  end

  def create_dirs() do
    if not File.exists?(@outdir), do: File.mkdir!(@outdir)
  end
end
