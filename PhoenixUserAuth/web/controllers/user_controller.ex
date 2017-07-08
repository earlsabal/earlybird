defmodule UserAuth.UserController do
  use UserAuth.Web, :controller

   def index(conn, _params) do
    users = Repo.all(UserAuth.User)

    json conn_with_status(conn, users), users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(UserAuth.User, String.to_integer(id))

    json conn_with_status(conn, user), user
  end

  def create(conn, params) do
     # json conn, nil
    changeset = UserAuth.User.changeset(
      %UserAuth.User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        json conn |> put_status(:created), user
      {:error, _changeset} ->
        json conn |> put_status(:bad_request), %{errors: ["unable to create user"] }
    end
  end

  def update(conn, %{"id" => id} = params) do
    user = Repo.get(UserAuth.User, id)
    if user do
      perform_update(conn, user, params)
    else
      json conn |> put_status(:not_found),
            %{errors: ["invalid user"]}
    end
  end

  defp perform_update(conn, user, params) do
    changeset = UserAuth.User.changeset(user, params)
    case Repo.update(changeset) do
      {:ok, user} ->
        json conn |> put_status(:ok), user
      {:error, _result} ->
        json conn |> put_status(:bad_request),
                     %{errors: ["unable to update user"]}
    end
  end

  defp conn_with_status(conn, nil) do
    conn
      |> put_status(:not_found)
  end

  defp conn_with_status(conn, _) do
    conn
      |> put_status(:ok)
  end
end

