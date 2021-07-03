defmodule DashyWeb.PageLive do
  use DashyWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :refresh_time, 20)
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

  defp render_time(datetime) do
    Calendar.strftime(datetime, "%B %d %Y %H:%M:%S")
  end
end
