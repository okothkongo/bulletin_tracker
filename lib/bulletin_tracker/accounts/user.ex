defmodule BulletinTracker.Accounts.User do
  use BulletinTracker.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string
    field :priority_date, :date
    field :visa_type, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :priority_date, :password, :visa_type])
    |> validate_required([:email, :priority_date, :password, :visa_type])
  end
end
