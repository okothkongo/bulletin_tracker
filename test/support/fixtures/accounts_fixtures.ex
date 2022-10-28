defmodule BulletinTracker.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BulletinTracker.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        password: "some password",
        priority_date: "some priority_date",
        visa_type: "some visa_type"
      })
      |> BulletinTracker.Accounts.create_user()

    user
  end
end
