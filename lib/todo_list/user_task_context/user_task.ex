defmodule TodoList.UserTaskContext.UserTask do
  use Ecto.Schema
  import Ecto.Changeset
  alias TodoList.TaskContext.Task
  alias TodoList.UserContext.User

  schema "users_tasks" do
    field :accepted, :boolean, default: false
    belongs_to :user, User
    belongs_to :task, Task

  end

  def changeset(user_task, attrs) do
    user_task
    |> cast(attrs, [:user_id, :task_id, :accepted])
    |> validate_required([:user_id, :task_id])
    |> unique_constraint(:users_tasks_user_id_task_id_index, name: :unique_constraint_name)
  end


end
