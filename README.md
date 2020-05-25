# Animedl

"Greetings und willkommen." ~ Manwholikespie, fulfilling his per-repo greeting quota.

## What is this?
It's a way to bulk download torrent files that match a given query on certain public anime trackers (currently only [Nyaa](https://nyaa.si) is implemented).

## How do I use it?
1. Install elixir: `$ brew install elixir`
2. Download this code, and navigate to its directory: `$ git clone <url>; cd animedl`
3. Run its mix task: `$ mix get 'this is my query'`
4. See downloaded files in `files/`
5. Drag and drop those into your favorite downloader (Transmission is nice) or pester me into writing an Elixir wrapper for aria2.

## What was your inspiration?
MacOS decided to break my OpenSSL dylibs for the third time in two weeks, and I figured it would be easier to rewrite my python nyaa downloader in elixir than fix those libraries again. I probably just needed to reinstall requests and have it find the new libraries, but whatever.