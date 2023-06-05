defmodule TodoList.TaskContextTest do
  use TodoList.DataCase

  alias TodoList.TaskContext

  describe "tasks" do
    alias TodoList.TaskContext.Task

    import TodoList.TaskContextFixtures

    @invalid_attrs %{" title": nil, body: nil, created_at: nil, deadline: nil, status: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert TaskContext.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert TaskContext.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{" title": "some  title", body: "some body", created_at: ~N[2023-05-14 12:22:00], deadline: ~D[2023-05-14], status: true}

      assert {:ok, %Task{} = task} = TaskContext.create_task(valid_attrs)
      assert task. title == "some  title"
      assert task.body == "some body"
      assert task.created_at == ~N[2023-05-14 12:22:00]
      assert task.deadline == ~D[2023-05-14]
      assert task.status == true
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TaskContext.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{" title": "some updated  title", body: "some updated body", created_at: ~N[2023-05-15 12:22:00], deadline: ~D[2023-05-15], status: false}

      assert {:ok, %Task{} = task} = TaskContext.update_task(task, update_attrs)
      assert task. title == "some updated  title"
      assert task.body == "some updated body"
      assert task.created_at == ~N[2023-05-15 12:22:00]
      assert task.deadline == ~D[2023-05-15]
      assert task.status == false
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = TaskContext.update_task(task, @invalid_attrs)
      assert task == TaskContext.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = TaskContext.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> TaskContext.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = TaskContext.change_task(task)
    end
  end
end
