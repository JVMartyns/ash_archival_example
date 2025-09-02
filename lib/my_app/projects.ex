defmodule MyApp.Projects do
  use Ash.Domain, otp_app: :zen_flow, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource MyApp.Projects.Project
    resource MyApp.Projects.ProjectUser
    resource MyApp.Projects.Task
  end
end
