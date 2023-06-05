defmodule TodoList.TaskContext.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias TodoList.UserContext.User

  schema "tasks" do
    field :body, :string
    field :created_at, :date, default: Date.utc_today
    field :status, :boolean, default: false
    field :title, :string
    field :deadline, :naive_datetime


    many_to_many :users, User, join_through: "users_tasks", on_replace: :delete

  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :body, :status, :created_at, :deadline])
    |> validate_required([:title, :body, :status, :created_at, :deadline])
  end
end
