defmodule BulletinTracker.Repo.Migrations.AddPartOfTheWorldToBulletinsTable do
  use Ecto.Migration

  def change do
    alter table(:bulletins) do
      add :part_of_the_world, :string
    end

    drop index(:bulletins, [:category])
    create unique_index(:bulletins, [:category, :priority_date])
  end
end
