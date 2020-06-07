defmodule TattlerWeb.Router do
  use TattlerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TattlerWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/chat", PageController, only: [:show]
    resources "/users", UserController
    resources "/session", SessionController, only: [:new, :create, :delete],
                                             singleton: true
  end

  scope "/chat", TattlerWeb do
    # pipe_through [:browser, :authenticate_user, :put_user_token]
    pipe_through :browser
    get "/", PageController, :show
  end

  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: "/session/new")
        |> halt()
      user_id ->
        assign(conn, :current_user, Tattler.Accounts.get_user!(user_id))
    end
  end

  defp put_user_token(conn, _) do
    if current_user = conn.assigns[:current_user] do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", TattlerWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TattlerWeb.Telemetry
    end
  end
end
