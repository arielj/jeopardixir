defmodule Jeopardixir.Board.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias Jeopardixir.Board.Answer

  schema "categories" do
    field :name, :string

    has_many :answers, Answer

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
