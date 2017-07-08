defmodule UserAuth.Session do
  alias UserAuth.User
  alias UserAuth.RegistrationController
  # alias UserAuth.Session
  # import Registration

  def login(params, repo) do
    user = repo.get_by(User, username: String.downcase(params["username"]))
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
    end
  end

  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: UserAuth.Repo.get_by(User, id)
  end

  def logged_in?(conn) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: logged_in? = true
  end

end
