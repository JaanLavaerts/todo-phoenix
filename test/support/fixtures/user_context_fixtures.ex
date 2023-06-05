defmodule TodoList.UserContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoList.UserContext` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        date_of_birth: ~N[2023-04-20 09:35:00],
        first_name: "some first_name",
        id: 42,
        last_name: "some last_name",
        role: "some role"
      })
      |> TodoList.UserContext.create_user()

    user
  end
end
