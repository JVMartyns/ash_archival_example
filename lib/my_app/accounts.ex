defmodule MyApp.Accounts do
  use Ash.Domain, otp_app: :my_app, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource MyApp.Accounts.Token
    resource MyApp.Accounts.User
  end
end
