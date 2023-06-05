defmodule TodoListWeb.Router do
  use TodoListWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TodoListWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug TodoListWeb.Plugs.Locale
  end

  pipeline :auth do
    plug TodoListWeb.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :allowed_for_users do
    plug TodoListWeb.Plugs.AuthorizationPlug, ["Admin", "User"]
  end

  pipeline :allowed_for_admins do
    plug TodoListWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

  scope "/", TodoListWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
    get "/register", UserController, :new
    post "/register", UserController, :create

  end

  scope "/", TodoListWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]

    get "/tasks", TaskController, :tasks_by_user
    get "/invites", TaskController, :invites_by_user
    post "/invites/accept_task/:task_id", TaskController, :accept_task
    get "/tasks/completed/:task_id", TaskController, :completed
    get "/tasks/new", TaskController, :new
    get "/tasks/:id", TaskController, :invite
    post "/tasks/assign_user/:task_id", TaskController, :assign_user
    resources("/tasks", TaskController, except: [:show])

  end

  scope "/admin", TodoListWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]

    resources("/users", UserController)
    get "/", PageController, :admin_index
    get "/tasks", TaskController, :all_tasks
  end

  scope "/", TodoListWeb do
    pipe_through :browser

    get "/*path", NotFoundController, :index
  end

end
