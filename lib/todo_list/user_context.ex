defmodule TodoList.UserContext do
  import Ecto.Query, warn: false
  alias TodoList.Repo

  alias TodoList.UserContext.User
  alias TodoList.UserTaskContext.UserTask
  import TodoListWeb.Gettext

  defdelegate get_acceptable_roles(), to: User

  def list_users do
    Repo.all(User)
  end

  def get_available_users(current_user_id, task_id) do
    query =
      from u in User,
        left_join: ut in UserTask, on: u.id == ut.user_id and ut.task_id == ^task_id,
        where: u.id != ^current_user_id and is_nil(ut.id)

    Repo.all(query)
  end


  def get_users_by_task_id(task_id) do
    query =
      from u in User,
        join: ut in UserTask,
        where: ut.task_id == ^task_id and ut.user_id == u.id

    Repo.all(query)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_user(username, plain_text_password) do
    case Repo.get_by(User, username: username) do
      nil ->
        Pbkdf2.no_user_verify()
        {:error, gettext("No user with this username")}

      user ->
        if Pbkdf2.verify_pass(plain_text_password, user.hashed_password) do
          {:ok, user}
        else
          {:error, gettext("Incorrect password")}
        end
    end
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end
end
