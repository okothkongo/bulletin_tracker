defmodule BulletinTracker do
  @moduledoc """
  BulletinTracker keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @base_url Application.fetch_env!(:bulletin_tracker, :base_url)
  @additional_text Application.fetch_env!(:bulletin_tracker, :additional_text)

  def get_category_and_date() do
    {category, date} =
      fetch_content()
      |> build_category_and_date()

    %{priority_date: parse_date!(date), category: category}
  end

  defp parse_date!(<<day::binary-size(2), month::binary-size(3), year::binary-size(2)>>) do
    Date.new!(String.to_integer("20" <> year), build_month_in_num[month], String.to_integer(day))
  end

  def build_category_and_date(<<category::binary-size(2), date::binary-size(7)>>) do
    {category, date}
  end

  def fetch_content do
    get_bulletin_url()
    |> Crawly.fetch()
    |> case do
      %{status_code: 404} ->
        "we will talk later"

      %{body: content, status_code: 200} ->
        content
        |> parse_content()
        |> get_action_date()
    end
  end

  defp parse_content(content) do
    content
    |> Floki.parse_document!()
    |> Floki.find("table")
    |> Floki.text()
    |> String.split(" ", trim: true)
    |> IO.inspect()
    |> Enum.at(7)
    |> String.split(["\n"], trim: true)
    |> Enum.at(0)
  end

  def get_action_date(<<_countries::binary-size(28), due_date::binary-size(9)>>) do
    due_date
  end

  def get_bulletin_url() do
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

  defp build_month_in_num do
    %{
      "JAN" => 1,
      "FEB" => 2,
      "MAR" => 3,
      "APR" => 4,
      "MAY" => 5,
      "JUN" => 6,
      "JUL" => 7,
      "AUG" => 8,
      "SEP" => 9,
      "OCT" => 10,
      "NOV" => 11,
      "DEC" => 12
    }
  end
end
