defmodule NewsComponent do
  use Phoenix.LiveComponent

  def mount(socket) do
    {:ok, assign(socket, article: nil)}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    ~L"""
    <%= if @article do %>
      <span href="<%= @article[:url] %>" class="inline-block align-middle text-gray-700 text-lg truncate mx-4">
        <%= @article[:title] %>
      </span>
      <p class ="text-xs mx-4 text-gray-500 text-center">
        <%= @article[:abstract] %>
      </p>
    <% else %>
      <span class="inline-block align-middle text-gray-800 text-xl truncate mx-4">
        Loading...
      </span>
    <% end %>
    """
  end
end
