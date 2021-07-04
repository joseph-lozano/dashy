defmodule DashyWeb.PageLive do
  use DashyWeb, :live_view

  alias Dashy.NYTimes

  @news_refresh_rate :timer.seconds(30)

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      send(self(), :refresh_time)
      Process.send_after(self(), :show_new_article, @news_refresh_rate)
      send_update(NewsComponent, id: :news_component, article: NYTimes.get_article())
    end

    {:ok,
     assign(socket,
       time: render_time(DateTime.utc_now())
     )}
  end

  @impl true
  def handle_info(:refresh_time, socket) do
    Process.send_after(self(), :refresh_time, 50)

    time = render_time(DateTime.utc_now())
    {:noreply, assign(socket, time: time)}
  end

  def handle_info(:show_new_article, socket) do
    IO.puts("NEW ARTICLE")
    Process.send_after(self(), :show_new_article, @news_refresh_rate)
    send_update(NewsComponent, id: :news_component, article: NYTimes.get_article())

    {:noreply, socket}
  end

  defp render_time(datetime) do
    Calendar.strftime(datetime, "%B %d %Y %H:%M:%S")
  end
end
