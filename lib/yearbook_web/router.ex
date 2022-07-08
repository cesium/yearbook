defmodule YearbookWeb.Router do
  use YearbookWeb, :router

  import YearbookWeb.Plugs.Auth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {YearbookWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", YearbookWeb do
    pipe_through :api
  end

  scope "/", YearbookWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/terms", PageController, :terms

    scope "/" do
      pipe_through :redirect_if_user_is_authenticated

      get "/register", UserRegistrationController, :new
      post "/register", UserRegistrationController, :create
      get "/login", UserSessionController, :new
      post "/login", UserSessionController, :create
      get "/reset_password", UserResetPasswordController, :new
      post "/reset_password", UserResetPasswordController, :create
      get "/reset_password/:token", UserResetPasswordController, :edit
      put "/reset_password/:token", UserResetPasswordController, :update
    end

    scope "/auth" do
      delete "/log_out", UserSessionController, :delete
      get "/confirm", UserConfirmationController, :new
      post "/confirm", UserConfirmationController, :create
      get "/confirm/:token", UserConfirmationController, :edit
      post "/confirm/:token", UserConfirmationController, :update
    end

    scope "/settings" do
      pipe_through :require_authenticated_user

      get "/", UserSettingsController, :edit
      put "/", UserSettingsController, :update
      get "/confirm_email/:token", UserSettingsController, :confirm_email
    end

    live_session :logged_in, on_mount: [{YearbookWeb.Hooks, :current_user}] do
      live "/yearbook/:class_id", YearbookLive.Show, :show

      scope "/admin", Admin, as: :admin do
        live "/academic_years", AcademicYearLive.Index, :index
        live "/academic_years/new", AcademicYearLive.Index, :new
        live "/academic_years/:id/edit", AcademicYearLive.Index, :edit
        live "/academic_years/:id", AcademicYearLive.Show, :show
        live "/academic_years/:id/show/edit", AcademicYearLive.Show, :edit

        live "/degrees", DegreeLive.Index, :index
        live "/degrees/new", DegreeLive.Index, :new
        live "/degrees/:id/edit", DegreeLive.Index, :edit
        live "/degrees/:id", DegreeLive.Show, :show
        live "/degrees/:id/show/edit", DegreeLive.Show, :edit

        live "/classes", ClassLive.Index, :index
        live "/classes/new", ClassLive.Index, :new
        live "/classes/:id/edit", ClassLive.Index, :edit
        live "/classes/:id/show/edit", ClassLive.Show, :edit
      end
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: YearbookWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
