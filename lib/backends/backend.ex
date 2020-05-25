defmodule Animedl.Backend do
  @callback url(String.t()) :: String.t()
  @callback parse_page(term) :: [Animedl.Models.Anime.t()]
end
