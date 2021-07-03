defmodule DashyWeb.PageLive do
  use DashyWeb, :live_view

  alias Dashy.NewsApi

  @impl true
  def mount(_params, _session, socket) do
    %{article: article} =
      if connected?(socket) do
        send(self(), :refresh_time)
        send(self(), :show_new_article)

        article =
          NewsApi.get_articles()
          |> Enum.random()

        %{article: article}
      else
        %{article: nil}
      end

    {:ok,
     assign(socket,
       time: render_time(DateTime.utc_now()),
       article: article
     )}
  end

  @impl true
  def handle_info(:refresh_time, socket) do
    Process.send_after(self(), :refresh_time, 50)

    time = render_time(DateTime.utc_now())
    {:noreply, assign(socket, time: time)}
  end

  def handle_info(:show_new_article, socket) do
    Process.send_after(self(), :show_new_article, :timer.seconds(3))

    article =
      NewsApi.get_articles()
      |> Enum.random()

    {:noreply, assign(socket, article: article)}
  end

  defp render_time(datetime) do
    Calendar.strftime(datetime, "%B %d %Y %H:%M:%S")
  end
end
