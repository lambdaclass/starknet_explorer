defmodule :"Elixir.StarknetExplorer.Repo.Migrations.Add-contracts-and-classes" do
  use Ecto.Migration

  def change do
    create table("classes", primary_key: false) do
      add :hash, :string, primary_key: true
      add :timestamp, :integer
      add :declared_by_address, :string
      add :version, :string
      add :network, :string, null: false
      add :declared_at_transaction, :string

      timestamps()
    end

    create table("contracts", primary_key: false) do
      add :address, :string, primary_key: true
      add :deployed_by_address, :string
      add :timestamp, :integer
      add :version, :string
      add :balance, :string
      add :type, :string
      add :nonce, :string
      add :network, :string, null: false
      timestamps()

      references("classes",
        on_delete: :delete_all,
        column: :hash,
        name: :class_hash,
        prefix: nil,
        type: :string
      )

      references("transactions",
        on_delete: :delete_all,
        column: :hash,
        name: :deployed_at_transaction,
        prefix: nil,
        type: :string
      )
    end
  end
end
