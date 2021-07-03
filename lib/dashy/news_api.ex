defmodule Dashy.NewsApi do
  use GenServer

  defstruct articles: [], last_update: nil, current_task: nil

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    {:ok, %__MODULE__{}, {:continue, :initialize}}
  end

  def handle_continue(:initialize, state) do
    task = Task.async(&us_headlines/0)
    new_state = put_in(state.current_task, task)
    {:noreply, new_state}
  end

  def handle_info({ref, result}, %{current_task: %Task{ref: task_ref}} = state)
      when ref == task_ref do
    {:ok, articles} = result

    {:noreply,
     %__MODULE__{state | articles: articles, current_task: nil, last_update: DateTime.utc_now()}}
  end

  def handle_info({:DOWN, _ref, :process, _pid, :normal}, state) do
    {:noreply, state}
  end

  def handle_call(:get_articles, _, state) do
    {:reply, state.articles, state}
  end

  def get_articles() do
    GenServer.call(__MODULE__, :get_articles)
  end

  defp api_key() do
    Application.get_env(:dashy, __MODULE__)[:api_key]
  end

  # defp us_headlines() do
  #   with {:ok, %{body: json_body}} <-
  #          HTTPoison.get("https://newsapi.org/v2/top-headlines?country=us&apiKey=#{api_key()}"),
  #        {:ok, %{articles: articles}} <- Jason.decode(json_body, keys: :atoms) do
  #     {:ok, articles}
  #   end
  # end

  defp us_headlines() do
    "priv/news_api/example_response"
    |> File.read!()
    |> :erlang.binary_to_term()
  end
end