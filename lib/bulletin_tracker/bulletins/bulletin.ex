defmodule BulletinTracker.Bulletins.Bulletin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bulletins" do
    field :category, :string
    field :priority_date, :date

    timestamps()
  end

  @doc false
  def changeset(bulletin, attrs) do
    bulletin
    |> cast(attrs, [:category, :priority_date])
    |> validate_required([:category, :priority_date])
    |> unique_constraint(:category)
  end
end
