defmodule BulletinTracker.ContentFetchingJob do
  use GenServer
  alias BulletinTracker.Bulletins

  def start_link({"", name}) do
    GenServer.start_link(__MODULE__, "", name: name)
  end

  def init(state) do
    send_monthly_message()
    {:ok, state}
  end

  def handle_info(:fetch_content, _state) do
    send_monthly_message()

    BulletinTracker.get_category_and_date()
    |> Bulletins.upsert_bulletin()

    {:noreply, ""}
  end

  defp send_monthly_message(), do: :timer.send_interval(2_222_220_000, self(), :fetch_content)
end
