defmodule Animedl.Models do
  defmodule Anime do
    defstruct [
      :title,
      :url,
      :url_magnet,
      :url_torrent,
      :url_direct,
      :size,
      :date,
      :n_seeders,
      :n_leechers,
      :n_downloads,
      :n_comments
    ]
  end
end
