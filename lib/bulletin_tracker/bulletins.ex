defmodule BulletinTracker.Bulletins do
  @moduledoc """
  The Bulletins context.
  """

  import Ecto.Query, warn: false
  alias BulletinTracker.Repo

  alias BulletinTracker.Bulletins.Bulletin

  @doc """
  Returns the list of bulletins.

  ## Examples

      iex> list_bulletins()
      [%Bulletin{}, ...]

  """
  def list_bulletins do
    Repo.all(Bulletin)
  end

  @doc """
  Gets a single bulletin.

  Raises `Ecto.NoResultsError` if the Bulletin does not exist.

  ## Examples

      iex> get_bulletin!(123)
      %Bulletin{}

      iex> get_bulletin!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bulletin!(id), do: Repo.get!(Bulletin, id)

  @doc """
  Creates a bulletin.

  ## Examples

      iex> upsert_bulletin(%{field: value})
      {:ok, %Bulletin{}}

      iex> upsert_bulletin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def upsert_bulletin(attrs \\ %{}) do
    %Bulletin{}
    |> Bulletin.changeset(attrs)
    |> Repo.insert(
      on_conflict: {:replace, [:priority_date]},
      conflict_target: [:category, :priority_date],
      returning: true
    )
  end

  @doc """
  Updates a bulletin.

  ## Examples

      iex> update_bulletin(bulletin, %{field: new_value})
      {:ok, %Bulletin{}}

      iex> update_bulletin(bulletin, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bulletin(%Bulletin{} = bulletin, attrs) do
    bulletin
    |> Bulletin.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bulletin.

  ## Examples

      iex> delete_bulletin(bulletin)
      {:ok, %Bulletin{}}

      iex> delete_bulletin(bulletin)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bulletin(%Bulletin{} = bulletin) do
    Repo.delete(bulletin)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bulletin changes.

  ## Examples

      iex> change_bulletin(bulletin)
      %Ecto.Changeset{data: %Bulletin{}}

  """
  def change_bulletin(%Bulletin{} = bulletin, attrs \\ %{}) do
    Bulletin.changeset(bulletin, attrs)
  end
end
