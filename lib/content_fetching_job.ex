defmodule BulletinTracker.ContentFetchingJob do
  use GenServer

  def start_link({"", name}) do
    GenServer.start_link(__MODULE__, "", name: name)
  end

  def init(state) do
    send_monthly_message()
    {:ok, state}
  end

  def handle_info(:fetch_content, _state) do
    send_monthly_message()
    BulletinTracker.fetch_content()
    {:noreply, ""}
  end

  defp send_monthly_message(), do: :timer.send_interval(86400 * 30, self(), :fetch_content)
end
