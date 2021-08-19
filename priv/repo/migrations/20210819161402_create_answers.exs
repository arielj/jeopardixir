defmodule Jeopardixir.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :body, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end

    create index(:answers, [:user_id])
    create index(:answers, [:category_id])
  end
end
