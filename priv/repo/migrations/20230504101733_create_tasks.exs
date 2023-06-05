defmodule TodoList.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :body, :text
      add :status, :boolean, default: false, null: false
      add :created_at, :date
      add :deadline, :naive_datetime
    end
  end
end
