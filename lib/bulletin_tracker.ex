defmodule BulletinTracker do
  @moduledoc """
  BulletinTracker keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  require Logger
  @base_url System.get_env("BASE_URL")
  @additional_text System.get_env("ADDITIONAL_TEXT")

  def get_bulletin_data() do
    get_category_and_date()
    |> Enum.map(fn {key, value} -> {key, Enum.zip(value, build_country())} end)
  end

  def retry_fetching_content do
    fetch_content()
  end

  defp build_country() do
    ["Rest Of The World", "Mainland China", "India", "Mexico", "Philippines"]
  end

  defp get_category_and_date() do
    fetch_content()
    |> parse_content()
    |> BulletinTracker.Parser.parser()
  end

  defp parse_content(content) do
    content
    |> Floki.parse_document!()
    |> Floki.find("table")
    |> Floki.text()
  end

  defp fetch_content do
    get_bulletin_url()
    |> Crawly.fetch()
    |> case do
      %{body: content, status_code: 200} ->
        content

      error ->
        Logger.error("Fetching Content failed in #{inspect(__MODULE__)}, error: #{error}")
        :timer.apply_after(60000 * 5, __MODULE__, :retry_fetching_content, [])
    end
  end

  defp get_bulletin_url() do
    date = Date.utc_today()
    fin_year = get_current_financial_year(date)

    "#{@base_url}#{fin_year}#{@additional_text}#{get_month_in_alpha(date.month)}-#{date.year}.html"
  end

  defp get_current_financial_year(date) do
    if date.month > 9 do
      date.year + 1
    else
      date.year
    end
  end

  defp get_month_in_alpha(month) do
    build_month_in_alpha()[to_string(month)]
  end

  defp build_month_in_alpha do
    %{
      "1" => "january",
      "2" => "febraury",
      "3" => "march",
      "4" => "april",
      "5" => "may",
      "6" => "june",
      "7" => "july",
      "8" => "august",
      "9" => "september",
      "10" => "october",
      "11" => "november",
      "12" => "december"
    }
  end
end
