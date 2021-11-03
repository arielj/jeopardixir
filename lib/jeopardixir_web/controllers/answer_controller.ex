defmodule JeopardixirWeb.AnswerController do
  use JeopardixirWeb, :controller

  alias Jeopardixir.Answers
  alias Jeopardixir.Board.Answer

  def index(conn, _params) do
    answers = Answers.list_answers()
    render(conn, "index.html", answers: answers)
  end

  def new(conn, _params) do
    changeset = Answers.change_answer(%Answer{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"answer" => answer_params}) do
    case Answers.create_answer(answer_params) do
      {:ok, answer} ->
        conn
        |> put_flash(:info, "Answer created successfully.")
        |> redirect(to: Routes.answer_path(conn, :show, answer))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    answer = Answers.get_answer!(id)
    render(conn, "show.html", answer: answer)
  end

  def edit(conn, %{"id" => id}) do
    answer = Answers.get_answer!(id)
    changeset = Answers.change_answer(answer)
    render(conn, "edit.html", answer: answer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "answer" => answer_params}) do
    answer = Answers.get_answer!(id)

    case Answers.update_answer(answer, answer_params) do
      {:ok, answer} ->
        conn
        |> put_flash(:info, "Answer updated successfully.")
        |> redirect(to: Routes.answer_path(conn, :show, answer))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", answer: answer, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    answer = Answers.get_answer!(id)
    {:ok, _answer} = Answers.delete_answer(answer)

    conn
    |> put_flash(:info, "Answer deleted successfully.")
    |> redirect(to: Routes.answer_path(conn, :index))
  end
end
