defmodule BulletinTracker do
  @moduledoc """
  BulletinTracker keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  # @base_url Application.fetch_env!(:bulletin_tracker, :base_url)
  # @additional_text Application.fetch_env!(:bulletin_tracker, :additional_text)

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
      "1" => "January",
      "2" => "Febraury",
      "3" => "March",
      "4" => "April",
      "5" => "May",
      "6" => "June",
      "7" => "July",
      "8" => "August",
      "9" => "September",
      "10" => "october",
      "11" => "November",
      "12" => "December"
    }
  end
end
