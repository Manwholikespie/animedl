defmodule Animedl.Fetch do
  alias Animedl.Models.Anime
  alias Animedl.Backends.Nyaa

  @num_workers Application.fetch_env!(:animedl, :workers)
  @outdir Application.fetch_env!(:animedl, :outdir)

  @spec search(String.t()) :: Anime.t()
  def search(query) do
    query
    |> Nyaa.url()
    |> get_page()
    |> Nyaa.parse_page()
  end

  @spec download_parallel([Anime.t()]) :: :ok
  def download_parallel(animes, mode \\ :torrent_file) do
    case mode do
      :torrent_file ->
        animes
        |> Animedl.Parallel.run(@num_workers, fn a ->
          IO.puts("Downloading #{a.title}")
          writepath = download_torrent_file(a)
          IO.puts("Saved to #{writepath}")
        end)

        :ok

      :torrent_dl ->
        raise "Not yet implemented"

      :magnet_dl ->
        raise "Not yet implemented"
    end
  end

  @spec download_torrent_file(Anime.t()) :: String.t()
  defp download_torrent_file(a) do
    writepath = Path.join(@outdir, "#{a.title}.torrent")

    a.url_torrent
    |> get_page()
    |> (&File.write(writepath, &1)).()

    writepath
  end

  defp get_page(url) do
    {:ok, %HTTPoison.Response{body: page}} = HTTPoison.get(url)
    page
  end
end
