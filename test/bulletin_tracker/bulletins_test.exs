defmodule BulletinTracker.BulletinsTest do
  use BulletinTracker.DataCase

  alias BulletinTracker.Bulletins

  describe "bulletins" do
    alias BulletinTracker.Bulletins.Bulletin

    import BulletinTracker.BulletinsFixtures

    @invalid_attrs %{category: nil, priority_date: nil}

    test "list_bulletins/0 returns all bulletins" do
      bulletin = bulletin_fixture()
      assert Bulletins.list_bulletins() == [bulletin]
    end

    test "get_bulletin!/1 returns the bulletin with given id" do
      bulletin = bulletin_fixture()
      assert Bulletins.get_bulletin!(bulletin.id) == bulletin
    end

    test "create_bulletin/1 with valid data creates a bulletin" do
      valid_attrs = %{category: "some category", priority_date: ~N[2022-10-26 20:01:00]}

      assert {:ok, %Bulletin{} = bulletin} = Bulletins.create_bulletin(valid_attrs)
      assert bulletin.category == "some category"
      assert bulletin.priority_date == ~N[2022-10-26 20:01:00]
    end

    test "create_bulletin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bulletins.create_bulletin(@invalid_attrs)
    end

    test "update_bulletin/2 with valid data updates the bulletin" do
      bulletin = bulletin_fixture()
      update_attrs = %{category: "some updated category", priority_date: ~N[2022-10-27 20:01:00]}

      assert {:ok, %Bulletin{} = bulletin} = Bulletins.update_bulletin(bulletin, update_attrs)
      assert bulletin.category == "some updated category"
      assert bulletin.priority_date == ~N[2022-10-27 20:01:00]
    end

    test "update_bulletin/2 with invalid data returns error changeset" do
      bulletin = bulletin_fixture()
      assert {:error, %Ecto.Changeset{}} = Bulletins.update_bulletin(bulletin, @invalid_attrs)
      assert bulletin == Bulletins.get_bulletin!(bulletin.id)
    end

    test "delete_bulletin/1 deletes the bulletin" do
      bulletin = bulletin_fixture()
      assert {:ok, %Bulletin{}} = Bulletins.delete_bulletin(bulletin)
      assert_raise Ecto.NoResultsError, fn -> Bulletins.get_bulletin!(bulletin.id) end
    end

    test "change_bulletin/1 returns a bulletin changeset" do
      bulletin = bulletin_fixture()
      assert %Ecto.Changeset{} = Bulletins.change_bulletin(bulletin)
    end
  end
end
