defmodule MyApp.Projects.ProjectUser do
  use Ash.Resource,
    domain: MyApp.Projects,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshArchival.Resource]

  postgres do
    table "project_users"
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
    defaults [:read, :update, :destroy]

    create :create do
      primary? true
      accept [:project_id, :user_id]
    end
  end

  attributes do
    uuid_primary_key :id
    attribute :project_id, :uuid, allow_nil?: false, public?: true
    attribute :user_id, :uuid, allow_nil?: false, public?: true
    create_timestamp :created_at, public?: true
  end

  relationships do
    belongs_to :user, MyApp.Accounts.User
    belongs_to :project, MyApp.Projects.Project
  end

  identities do
    identity :unique_project_user, [:project_id, :user_id]
  end
end
