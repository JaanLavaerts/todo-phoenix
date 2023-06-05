defmodule TodoList.TaskContext do
  @moduledoc """
  The UserContext context.
  """

  import Ecto.Query, warn: false
  alias TodoList.Repo
  alias __MODULE__.Task
  alias TodoList.UserContext.User
  alias TodoList.UserTaskContext.UserTask

  def get_task!(id), do: Repo.get!(Task, id)
  def get_task(id), do: Repo.get(Task, id)

  def list_tasks do
    Repo.all(Task)
  end

  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def assign_task_to_owner(%Task{} = task, %User{} = user) do
    join_params = %UserTask{task_id: task.id, user_id: user.id, accepted: true}
    Repo.insert(join_params)
  end

  def accept_task(%Task{} = task, %User{} = user) do
    user_task = Repo.get_by(UserTask, task_id: task.id, user_id: user.id)
    changeset = UserTask.changeset(user_task, %{accepted: true})
    Repo.update(changeset)
  end


  def assign_task_to_user(%Task{} = task, %User{} = user) do
    join_params = %UserTask{task_id: task.id, user_id: user.id}
    Repo.insert(join_params)
  end

  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc "Delete a task"
  def delete_task(%Task{} = task), do: Repo.delete(task)

  def get_user_invited_tasks(%User{} = user) do
    query =
      from t in Task,
        join: ut in UserTask,
        where: ut.user_id == ^user.id and ut.task_id == t.id and ut.accepted == false
    Repo.all(query)
  end

  def get_user_accepted_tasks(%User{} = user) do
    query =
      from t in Task,
        join: ut in UserTask,
        where: ut.user_id == ^user.id and ut.task_id == t.id and ut.accepted == true
    Repo.all(query)
  end

  def get_usernames_by_task(%Task{} = task) do
    query =
      from u in User,
        join: ut in UserTask,
        where: ut.task_id == ^task.id and ut.user_id == u.id and ut.accepted == true,
        select: u.username

    Repo.all(query)
  end

  def add_usernames(task) do
    usernames = get_usernames_by_task(task)
    Map.put(task, :usernames, usernames)
  end

  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  def completed(%Task{} = task) do
    task
    |> Task.changeset(%{status: !task.status})
    |> Repo.update()
  end

  def format_time(naive_datetime) do
    formatted_day = String.pad_leading(to_string(naive_datetime.day), 2, "0") # pad_leading is for leading zeros
    formatted_month = String.pad_leading(to_string(naive_datetime.month), 2, "0")
    formatted_year = String.slice(to_string(naive_datetime.year), 0, 4)

    formatted_date = "#{formatted_day}/#{formatted_month}/#{formatted_year}"
    formatted_time = "#{naive_datetime.hour}:#{naive_datetime.minute}"

    "#{formatted_date} - #{formatted_time}"
  end






end
