defmodule BulletinTracker.Repo.Migrations.CreateBulletins do
  use Ecto.Migration

  def change do
    create table(:bulletins) do
      add :category, :string
      add :priority_date, :date

      timestamps()
    end

    create unique_index(:bulletins, [:category])
  end
end
