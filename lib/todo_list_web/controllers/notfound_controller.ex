defmodule TodoListWeb.NotFoundController do
  use TodoListWeb, :controller

  def index(conn, _params) do
    render(conn, "404.html")
  end
end
