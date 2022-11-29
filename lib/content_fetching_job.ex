defmodule BulletinTracker.ContentFetchingJob do
  use GenServer
  alias BulletinTracker.Bulletins

  def start_link({_, name}) do
    GenServer.start_link(__MODULE__, "", name: name)
  end

  def init(state) do
    send_monthly_message()
    {:ok, state}
  end

  def handle_info(:fetch_content, _state) do
    send_daily_message()

    BulletinTracker.get_bulletin_data()
    |> Enum.map(fn {key, value} ->
      value
      |> Enum.map(fn {date, country} ->
        Bulletins.upsert_bulletin(%{
          category: Atom.to_string(key),
          priority_date: date,
          part_of_the_world: country
        })
      end)
    end)

    {:noreply, :ok}
  end

  defp send_daily_message(), do: :timer.send_interval(60000 * 60 * 24, self(), :fetch_content)
end
