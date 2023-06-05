defmodule TodoList.TaskContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoList.TaskContext` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
         title: "some  title",
        body: "some body",
        created_at: ~N[2023-05-14 12:22:00],
        deadline: ~D[2023-05-14],
        status: true
      })
      |> TodoList.TaskContext.create_task()

    task
  end
end
