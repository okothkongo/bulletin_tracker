defmodule BulletinTracker.Bulletins.Bulletin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bulletins" do
    field :category, :string
    field :priority_date, :date
    field :part_of_the_world, :string

    timestamps()
  end

  @doc false
  def changeset(bulletin, attrs) do
    bulletin
    |> cast(attrs, [:category, :priority_date, :part_of_the_world])
    |> validate_required([:category, :priority_date, :part_of_the_world])
    |> unique_constraint([:category, :priority_date])
  end
end
