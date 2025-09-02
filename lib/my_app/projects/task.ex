defmodule MyApp.Projects.Task do
  use Ash.Resource,
    domain: MyApp.Projects,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshArchival.Resource]

  postgres do
    table "tasks"
    repo MyApp.Repo

    base_filter_sql "archived_at IS NULL"
  end

  archive do
    base_filter?(true)
  end

  resource do
    base_filter expr(is_nil(archived_at))
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      primary? true
      accept [:title, :description, :status, :project_id]
    end

    update :update do
      primary? true
      accept [:title, :description, :status]
    end
  end

  attributes do
    uuid_primary_key :id
    attribute :title, :string, allow_nil?: false
    attribute :description, :string
    attribute :status, :string, default: "pending"

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :project, MyApp.Projects.Project
  end

  identities do
    identity :unique_name_per_project, [:title, :project_id]
  end
end
