defmodule Dashy.Github do
  use GenServer

  @base_url "https://api.github.com/search/issues"

  def init(_) do
    {:ok, []}
  end

  def get_issues do
    query = "involves:#{username()} #{orgs()} #{repos()} is:open"
    IO.inspect(query)
    query_string = "q=#{URI.encode(query)}"

    %URI{
      path: @base_url,
      query: query_string
    }
    |> URI.to_string()
    |> HTTPoison.get([], hackney: [basic_auth: {username(), api_token()}])
    |> case do
      {:ok, %{body: body}} ->
        body
        |> Jason.decode!(keys: :atoms)
        |> Map.get(:items)
        |> Enum.map(fn item ->
          item
          |> update_in([:closed_at], &from_iso8601!(&1))
          |> update_in([:created_at], &from_iso8601!(&1))
          |> update_in([:updated_at], &from_iso8601!(&1))
        end)
    end
    |> Enum.sort(fn a, b ->
      DateTime.compare(a.updated_at, b.updated_at) == :gt
    end)
  end

  defp from_iso8601!(nil) do
    nil
  end

  defp from_iso8601!(str) do
    {:ok, dt, 0} = DateTime.from_iso8601(str)
    dt
  end

  defp api_token() do
    Application.get_env(:dashy, __MODULE__)[:api_key]
  end

  defp username() do
    Application.get_env(:dashy, __MODULE__)[:username]
  end

  defp repos() do
    Application.get_env(:dashy, __MODULE__)[:repos]
    |> case do
      list when is_list(list) -> Enum.map(list, &"repo:#{&1}") |> Enum.join(" ")
      _ -> ""
    end
  end

  defp orgs() do
    Application.get_env(:dashy, __MODULE__)[:orgs]
    |> case do
      list when is_list(list) -> Enum.map(list, &"org:#{&1}") |> Enum.join(" ")
      _ -> ""
    end
  end
end
