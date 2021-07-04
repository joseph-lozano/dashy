defmodule DashyWeb.GithubComponent do
  use Phoenix.LiveComponent

  def mount(socket) do
    {:ok, assign(socket, issues: [])}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    ~L"""
    <h1 class="text-center mt-2">My Issues</h1>
    <div class="mt-1 mx-2">
      <%= for issue <- Enum.take(@issues, 10) do %>
        <div class="w-full text-xs truncate leading-tight">
        <span class="text-gray-500">
          <%= repo(issue) %>
        </span>
        <span class=text-gray-800>
          <%= issue.title %>
        </span>
        </div>
      <% end %>
    </ol>
    """
  end

  defp repo(nil) do
    nil
  end

  defp repo(issue) do
    issue.repository_url
    |> Path.split()
    |> Enum.at(-1)
  end
end
