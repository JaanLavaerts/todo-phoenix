defmodule TodoList.Repo.Migrations.CreateUsersHaveTasks do
  use Ecto.Migration

  def change do
    create table(:users_tasks) do
      add :accepted, :boolean
      add :user_id, references(:users, on_delete: :delete_all)
      add :task_id, references(:tasks, on_delete: :delete_all)
    end
    create unique_index(:users_tasks, [:user_id, :task_id])
  end
end
