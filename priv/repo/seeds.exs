# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MyApp.Repo.insert!(%MyApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias MyApp.Accounts.User
alias MyApp.Projects.Project
alias MyApp.Projects.ProjectUser
alias MyApp.Projects.Task

if Mix.env() == :dev do
  admin =
    Ash.Seed.upsert!(
      User,
      %{
        email: "admin@email.ex",
        hashed_password: Bcrypt.hash_pwd_salt("myapp@2025", log_rounds: 1)
      },
      identity: :unique_email
    )

  project =
    Ash.Seed.upsert!(
      Project,
      %{name: "Project 1"},
      identity: :unique_name
    )

  Ash.Seed.upsert!(
    ProjectUser,
    %{project_id: project.id, user_id: admin.id},
    identity: :unique_project_user
  )

  Ash.Seed.upsert!(
    Task,
    %{
      title: "Task 1",
      description: "Description for Task 1",
      status: "pending",
      project_id: project.id
    },
    identity: :unique_name_per_project
  )
end
