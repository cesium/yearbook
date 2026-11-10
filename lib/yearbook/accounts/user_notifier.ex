defmodule Yearbook.Accounts.UserNotifier do
  @moduledoc """
  User notifier.
  """

  import Swoosh.Email
  alias Yearbook.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Yearbook", "contact@example.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc "Deliver account confirmation instructions."
  def deliver_user_confirmation_instructions(user, url) do
    deliver_confirmation_instructions(user, url)
  end

  @doc "Deliver password reset instructions."
  def deliver_password_reset_instructions(user, url) do
    deliver(user.email, "Password reset instructions", """

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request a password reset, please ignore this.

    ==============================
    """)
  end

  defp deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Confirmation instructions", """

    ==============================

    Hi #{user.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end
end
