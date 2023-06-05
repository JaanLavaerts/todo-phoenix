defmodule TodoList.UserContextTest do
  use TodoList.DataCase

  alias TodoList.UserContext

  describe "users" do
    alias TodoList.UserContext.User

    import TodoList.UserContextFixtures

    @invalid_attrs %{date_of_birth: nil, first_name: nil, id: nil, last_name: nil, role: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert UserContext.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserContext.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{date_of_birth: ~N[2023-04-20 09:35:00], first_name: "some first_name", id: 42, last_name: "some last_name", role: "some role"}

      assert {:ok, %User{} = user} = UserContext.create_user(valid_attrs)
      assert user.date_of_birth == ~N[2023-04-20 09:35:00]
      assert user.first_name == "some first_name"
      assert user.id == 42
      assert user.last_name == "some last_name"
      assert user.role == "some role"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserContext.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{date_of_birth: ~N[2023-04-21 09:35:00], first_name: "some updated first_name", id: 43, last_name: "some updated last_name", role: "some updated role"}

      assert {:ok, %User{} = user} = UserContext.update_user(user, update_attrs)
      assert user.date_of_birth == ~N[2023-04-21 09:35:00]
      assert user.first_name == "some updated first_name"
      assert user.id == 43
      assert user.last_name == "some updated last_name"
      assert user.role == "some updated role"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserContext.update_user(user, @invalid_attrs)
      assert user == UserContext.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserContext.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserContext.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserContext.change_user(user)
    end
  end
end
