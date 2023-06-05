defmodule TodoListWeb.TaskController do
  use TodoListWeb, :controller

  alias TodoListWeb.Guardian
  alias TodoList.TaskContext
  alias TodoList.TaskContext.Task
  alias TodoList.UserContext

  def new(conn, _params) do
    changeset = TaskContext.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    current_user = Guardian.Plug.current_resource(conn)

    case TaskContext.create_task(task_params) do
      {:ok, task} ->
        TaskContext.assign_task_to_owner(task, current_user)

        conn
        |> put_flash(:info, gettext("Task created successfully."))
        |> redirect(to: Routes.task_path(conn, :tasks_by_user))
      {:error, _} ->
        conn
        |> put_flash(:error, gettext("Failed to create task. Please fill in all fields."))
        |> redirect(to: Routes.task_path(conn, :new))

    end
  end

  # def invites(conn, %{"id" => id}) do
  #   tasks = TaskContext.get_user_invited_tasks(id)
  #   current_user = Guardian.Plug.current_resource(conn).id
  #   users = UserContext.get_available_users(current_user, id)
  #   render(conn, "index_invite.html", tasks: tasks, current_user: current_user)
  # end

  def accept_task(conn, %{"task_id" => id}) do
    task = TaskContext.get_task!(id)
    current_user = Guardian.Plug.current_resource(conn)
    case TaskContext.accept_task(task, current_user) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("Task accepted successfully."))
        |> redirect(to: Routes.task_path(conn, :tasks_by_user))

      {:error, _} ->
        conn
        |> put_flash(:error, gettext("Failed to accept task."))
        |> redirect(to: Routes.task_path(conn, :tasks_by_user))
    end
  end

  def invite(conn, %{"id" => id}) do
    task = TaskContext.get_task!(id)
    current_user = Guardian.Plug.current_resource(conn).id
    users = UserContext.get_available_users(current_user, id)
    render(conn, "invite.html", task: task, users: users)
  end

  def assign_user(conn, %{"task_id" => task_id, "user_id" => user_id}) do
    task = TaskContext.get_task!(task_id)
    user = UserContext.get_user!(user_id)

    case TaskContext.assign_task_to_user(task, user) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("User invited to task successfully."))
        |> redirect(to: Routes.task_path(conn, :invite, task_id))

      {:error, _} ->
        conn
        |> put_flash(:error, gettext("Failed to invite user."))
        |> redirect(to: Routes.task_path(conn, :invite, task_id))
    end
  end



  def edit(conn, %{"id" => id}) do
    task = TaskContext.get_task!(id)
    changeset = TaskContext.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = TaskContext.get_task!(id)

    case TaskContext.update_task(task, task_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("Task updated successfully."))
        |> redirect(to: Routes.task_path(conn, :tasks_by_user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = TaskContext.get_task!(id)
    {:ok, _task} = TaskContext.delete_task(task)

    conn
    |> put_flash(:info, gettext("Task deleted successfully."))
    |> redirect(to: Routes.task_path(conn, :index))
  end

  def invites_by_user(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    tasks = TaskContext.get_user_invited_tasks(current_user)
    render(conn, "index_invite.html", tasks: tasks, user: current_user)
  end


  def tasks_by_user(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    tasks = TaskContext.get_user_accepted_tasks(current_user)
    tasks_with_users = Enum.map(tasks, fn task ->
      task_with_username = TaskContext.add_usernames(task)
      deadline_format = TaskContext.format_time(task_with_username.deadline)
      Map.put(task_with_username, :deadline_format, deadline_format)
    end)
    title = "Tasks"
    render(conn, "index.html", tasks: tasks_with_users, current_user: current_user, title: title)
  end


  def all_tasks(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    tasks = TaskContext.list_tasks()
    tasks_with_users = Enum.map(tasks, fn task ->
      task_with_username = TaskContext.add_usernames(task)
      deadline_format = TaskContext.format_time(task_with_username.deadline)
      Map.put(task_with_username, :deadline_format, deadline_format)
    end)
    title = "Tasks (Admin view)"
    render(conn, "index.html", tasks: tasks_with_users, current_user: current_user, title: title)
  end

  def completed(conn, %{"task_id" => id}) do
    task = TaskContext.get_task!(id)
    {:ok, _task} = TaskContext.completed(task)

    conn
    |> redirect(to: Routes.task_path(conn, :tasks_by_user))
end

end
