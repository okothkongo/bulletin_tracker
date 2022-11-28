defmodule BulletinTracker.Parser do
  def parser(web_data) do
    web_data
    |> parse_family_priority_dates()
    |> build_family_priority_dates()
    |> parse_priority_dates_and_category
  end

  defp parse_family_priority_dates(
         <<_extra_data::binary-size(115), family_dates::binary-size(195),
           _the_rest_of_data::binary-size(2148)>>
       ) do
    family_dates
  end

  defp parse_family_priority_dates(
         <<_extra_data::binary-size(115), family_dates::binary-size(225),
           _the_rest_of_data::binary>>
       ) do
    family_dates
  end

  defp build_family_priority_dates(
         <<f1::binary-size(40), f2a::binary-size(8), f2b::binary-size(38), f3::binary-size(37),
           f4::binary-size(37), _rest_of_data::binary-size(35)>>
       ) do
    %{f1: String.replace(f1, "\n", "") |> String.trim(), f2a: f2a, f2b: f2b, f3: f3, f4: f4}
  end

  defp build_family_priority_dates(
         <<f1::binary-size(40), f2a::binary-size(38), f2b::binary-size(38), f3::binary-size(37),
           f4::binary-size(37), _rest_of_data::binary-size(35)>>
       ) do
    %{f1: String.replace(f1, "\n", "") |> String.trim(), f2a: f2a, f2b: f2b, f3: f3, f4: f4}
  end

  def parse_priority_dates_and_category(priority_dates) do
    priority_dates
    |> Enum.map(fn {key, value} ->
      key_to_string = key |> Atom.to_string() |> String.upcase()

      value =
        value
        |> String.replace(key_to_string, "")
        |> String.split("", trim: true)
        |> Enum.chunk_every(7)
        |> Enum.map(&(&1 |> Enum.join() |> build_date!()))

      {key, value}
    end)
    |> Enum.into(%{})
  end

  defp build_date!("CCCCC") do
    Date.utc_today()
  end

  defp build_date!(<<day::binary-size(2), month::binary-size(3), year::binary-size(2)>>) do
    Date.new!(
      String.to_integer("20" <> year),
      build_month_in_num()[month],
      String.to_integer(day)
    )
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
