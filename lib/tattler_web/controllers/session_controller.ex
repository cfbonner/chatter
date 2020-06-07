defmodule TattlerWeb.SessionController do
  use TattlerWeb, :controller

  alias Tattler.Accounts

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"email" => email}) do
    case Accounts.authenticate_by_email_password(email, "") do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Login successful")
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: "/chat")
      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Unauthorized")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
