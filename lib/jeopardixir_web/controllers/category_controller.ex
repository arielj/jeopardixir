defmodule JeopardixirWeb.CategoryController do
  use JeopardixirWeb, :controller

  alias Jeopardixir.Board
  alias Jeopardixir.Board.Category
  alias Jeopardixir.Board.Answer

  def index(conn, _params) do
    categories = Board.list_categories()
    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = Board.change_category(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    case Board.create_category(category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: Routes.category_path(conn, :show, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def add_answer(conn, %{"answer" => %{"body" => body }, "category_id" => category_id}) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    case Board.create_answer(%{body: body, category_id: category_id, user_id: user_id}) do
      {:ok, answer} ->
        conn
        |> put_flash(:info, "Answer created successfully.")
        |> redirect(to: Routes.category_path(conn, :show, category_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Board.get_category!(id)
    changeset = Board.change_answer(%Answer{})
    render(conn, "show.html", category: category, changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    category = Board.get_category!(id)
    changeset = Board.change_category(category)
    render(conn, "edit.html", category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Board.get_category!(id)

    case Board.update_category(category, category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: Routes.category_path(conn, :show, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Board.get_category!(id)
    {:ok, _category} = Board.delete_category(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: Routes.category_path(conn, :index))
  end
end
