defmodule Jeopardixir.Board.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  alias Jeopardixir.Board.Category
  alias Jeopardixir.Accounts.User

  schema "answers" do
    field :body, :string

    belongs_to :category, Category
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:body, :category_id, :user_id])
    |> validate_required([:body])
  end
end
