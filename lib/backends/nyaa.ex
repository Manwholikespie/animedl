defmodule Animedl.Backends.Nyaa do
  @behaviour Animedl.Backend

  alias Animedl.Models.Anime

  @impl Animedl.Backend
  def url(query) do
    "https://nyaa.si/?f=0&c=1_2&" <> URI.encode_query(%{"q" => query})
  end

  @impl Animedl.Backend
  def parse_page(page) do
    {:ok, document} = Floki.parse_document(page)

    document
    |> Floki.find("tbody > tr")
    |> Enum.map(fn tr ->
      [_category, title_comments, links, size, date, seeders, leechers, downloads] =
        tr |> Floki.find("td")

      {title, url, n_comments} =
        with title_as <- title_comments |> Floki.find("a") do
          case title_as |> length() do
            1 ->
              [title] = title_as
              {title |> Floki.text(), title |> Floki.attribute("href"), "?"}

            2 ->
              [comments, title] = title_as
              {title |> Floki.text(), title |> Floki.attribute("href"), comments}
          end
        end

      {url_torrent, url_magnet} =
        with [torrent, magnet] <- links |> Floki.find("a") do
          {
            torrent |> Floki.attribute("href") |> hd(),
            magnet |> Floki.attribute("href") |> hd()
          }
        end

      %Anime{
        title: title,
        url: prefix_url(url |> hd()),
        url_magnet: url_magnet,
        url_torrent: prefix_url(url_torrent),
        size: size |> Floki.text(),
        date: date |> Floki.text() |> parse_datetime(),
        n_seeders: seeders |> Floki.text() |> parse_int(),
        n_leechers: leechers |> Floki.text() |> parse_int(),
        n_downloads: downloads |> Floki.text() |> parse_int(),
        n_comments: n_comments |> Floki.text() |> parse_int()
      }
    end)
  end

  @spec prefix_url(String.t()) :: String.t()
  defp prefix_url(url_suffix) do
    "https://nyaa.si" <> url_suffix
  end

  @spec parse_int(String.t()) :: integer()
  defp parse_int("?"), do: 0

  defp parse_int(intstr) do
    {i, _} = Integer.parse(intstr)
    i
  end

  @spec parse_datetime(String.t()) :: DateTime.t()
  defp parse_datetime(dtstr) do
    # 2019-04-21 14:49
    Timex.parse!(dtstr <> "", "%F %R", :strftime)
  end
end
