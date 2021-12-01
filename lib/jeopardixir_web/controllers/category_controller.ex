defmodule JeopardixirWeb.CategoryController do
  use JeopardixirWeb, :controller

  alias Jeopardixir.Categories
  alias Jeopardixir.Answers
  alias Jeopardixir.Board.Category
  alias Jeopardixir.Board.Answer

  plug :require_user when action in [:new, :create, :add_answer]

  def index(conn, _params) do
    categories = Categories.list_categories()
    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = Categories.change_category(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    case Categories.create_category(category_params) do
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
    case Answers.create_answer(%{body: body, category_id: category_id, user_id: user_id}) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Answer created successfully.")
        |> redirect(to: Routes.category_path(conn, :show, category_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Categories.get_category!(id)
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    answers = Answers.get_answer_for_category(category.id, user_id)
    changeset = Answers.change_answer(%Answer{})
    render(conn, "show.html", category: category, changeset: changeset, answers: answers)
  end

  def edit(conn, %{"id" => id}) do
    category = Categories.get_category!(id)
    changeset = Categories.change_category(category)
    render(conn, "edit.html", category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Categories.get_category!(id)

    case Categories.update_category(category, category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: Routes.category_path(conn, :show, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Categories.get_category!(id)
    {:ok, _category} = Categories.delete_category(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: Routes.category_path(conn, :index))
  end
end
