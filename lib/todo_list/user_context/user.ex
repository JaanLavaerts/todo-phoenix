defmodule TodoList.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias TodoList.TaskContext.Task
  import TodoListWeb.Gettext

  @acceptable_roles ["Admin","User"]

  schema "users" do
    field :date_of_birth, :date
    field :first_name, :string
    field :last_name, :string
    field :role, :string, default: "User"
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :username, :string
    many_to_many :tasks, Task, join_through: "users_tasks"

  end

  def get_acceptable_roles, do: @acceptable_roles

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :date_of_birth, :role, :password, :username, :email])
    |> validate_required([:first_name, :last_name, :date_of_birth, :role, :password, :username, :email])
    |> validate_inclusion(:role, @acceptable_roles)
    |> unique_constraint([:username], name: :username, message: gettext("Username already used"))
    |> unique_constraint([:email], name: :email, message: gettext("Email already used"))
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset

end
