defmodule BulletinTracker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :email, :string
      add :priority_date, :date
      add :password, :string
      add :visa_type, :string
      add :id, :uuid, primary_key: true

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
