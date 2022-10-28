defmodule BulletinTracker.BulletinsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BulletinTracker.Bulletins` context.
  """

  @doc """
  Generate a bulletin.
  """
  def bulletin_fixture(attrs \\ %{}) do
    {:ok, bulletin} =
      attrs
      |> Enum.into(%{
        category: "some category",
        priority_date: ~N[2022-10-26 20:01:00]
      })
      |> BulletinTracker.Bulletins.create_bulletin()

    bulletin
  end
end
