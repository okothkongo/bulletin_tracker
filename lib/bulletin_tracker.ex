defmodule BulletinTracker do
  @moduledoc """
  BulletinTracker keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @base_url System.get_env("BASE_URL")
  @additional_text System.get_env("ADDITIONAL_TEXT")

  def get_category_and_date() do
    fetch_content()
    |> parse_content()
    |> BulletinTracker.Parser.parser()
  end

  defp fetch_content do
    get_bulletin_url()
    |> Crawly.fetch()
    |> case do
      %{status_code: 404} ->
        "we will talk later"

      %{body: content, status_code: 200} ->
        content
    end
  end

  defp parse_content(content) do
    content
    |> Floki.parse_document!()
    |> Floki.find("table")
    |> Floki.text()
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
