defmodule MyApp.Projects.Project do
  use Ash.Resource,
    domain: MyApp.Projects,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshArchival.Resource, AshAdmin.Resource]

  admin do
    label_field :name
  end

  archive do
    archive_related([:users, :tasks])
    archive_related_authorize?(false)
  end

  postgres do
    table "projects"
    repo MyApp.Repo

    base_filter_sql "archived_at IS NULL"
  end

  resource do
    base_filter expr(is_nil(archived_at))
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      primary? true
      accept [:name]
    end

    update :update do
      primary? true
      accept [:name]
    end
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string, allow_nil?: false, public?: true

    create_timestamp :created_at, public?: true
    update_timestamp :updated_at, public?: true
  end

  relationships do
    many_to_many :users, MyApp.Accounts.User do
      through MyApp.Projects.ProjectUser
    end

    has_many :tasks, MyApp.Projects.Task
  end

  identities do
    identity :unique_name, [:name]
  end
end
