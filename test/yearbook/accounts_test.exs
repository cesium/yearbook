defmodule Yearbook.AccountsTest do
  use Yearbook.DataCase

  alias Yearbook.Accounts

  import Yearbook.AccountsFixtures
  alias Yearbook.Accounts.{User, UserToken}

  describe "get_user_by_email/1" do
    test "does not return the user if the email does not exist" do
      refute Accounts.get_user_by_email("unknown@example.com")
    end

    test "returns the user if the email exists" do
      %{id: id} = user = user_fixture()
      assert %User{id: ^id} = Accounts.get_user_by_email(user.email)
    end
  end

  describe "get_user_by_email_and_password/2" do
    test "does not return the user if the email does not exist" do
      refute Accounts.get_user_by_email_and_password("unknown@example.com", "hello world!")
    end

    test "does not return the user if the password is not valid" do
      user = user_fixture() |> set_password()
      refute Accounts.get_user_by_email_and_password(user.email, "invalid")
    end

    test "returns the user if the email and password are valid" do
      %{id: id} = user = user_fixture() |> set_password()

      assert %User{id: ^id} =
               Accounts.get_user_by_email_and_password(user.email, valid_user_password())
    end

    test "does not return an unconfirmed user" do
      user = unconfirmed_user_fixture() |> set_password()
      refute Accounts.get_user_by_email_and_password(user.email, valid_user_password())
    end
  end

  describe "get_user!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!("11111111-1111-1111-1111-111111111111")
      end
    end

    test "returns the user with the given id" do
      %{id: id} = user = user_fixture()
      assert %User{id: ^id} = Accounts.get_user!(user.id)
    end
  end

  describe "register_user/1" do
    test "requires email to be set" do
      {:error, changeset} = Accounts.register_user(%{})

      assert %{email: ["can't be blank"]} = errors_on(changeset)
    end

    test "validates email when given" do
      {:error, changeset} = Accounts.register_user(%{email: "not valid"})

      assert %{email: ["must have the @ sign and no spaces"]} = errors_on(changeset)
    end

    test "requires matching password confirmation" do
      {:error, changeset} =
        Accounts.register_user(%{
          email: unique_user_email(),
          new_password: valid_user_password(),
          new_password_confirmation: "different password"
        })

      assert %{new_password_confirmation: ["does not match confirmation"]} = errors_on(changeset)
    end

    test "validates maximum values for email for security" do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Accounts.register_user(%{email: too_long})
      assert "should be at most 160 character(s)" in errors_on(changeset).email
    end

    test "validates email uniqueness" do
      %{email: email} = user_fixture()
      {:error, changeset} = Accounts.register_user(%{email: email})
      assert "has already been taken" in errors_on(changeset).email

      # Now try with the upper cased email too, to check that email case is ignored.
      {:error, changeset} = Accounts.register_user(%{email: String.upcase(email)})
      assert "has already been taken" in errors_on(changeset).email
    end

    test "registers users with a password" do
      email = unique_user_email()
      {:ok, user} = Accounts.register_user(valid_user_attributes(email: email))
      assert user.email == email
      assert user.hashed_password
      assert is_nil(user.confirmed_at)
      assert is_nil(user.new_password)
    end
  end

  describe "change_user_registration/3" do
    test "returns a user changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_registration(%User{})
      assert Enum.sort(changeset.required) == Enum.sort([:email, :new_password])
    end
  end

  describe "change_user_password/3" do
    test "returns a user changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_password(%User{})
      assert changeset.required == [:new_password]
    end

    test "allows fields to be set" do
      changeset =
        Accounts.change_user_password(
          user_fixture(),
          %{
            "current_password" => valid_user_password(),
            "new_password" => "new valid password",
            "new_password_confirmation" => "new valid password"
          },
          hash_password: false
        )

      assert changeset.valid?
      assert get_change(changeset, :new_password) == "new valid password"
      assert is_nil(get_change(changeset, :hashed_password))
    end
  end

  describe "update_user_password/2" do
    setup do
      %{user: user_fixture()}
    end

    test "validates password", %{user: user} do
      {:error, changeset} =
        Accounts.update_user_password(user, %{
          current_password: valid_user_password(),
          new_password: "not valid",
          new_password_confirmation: "another"
        })

      assert %{
               new_password: ["should be at least 12 character(s)"],
               new_password_confirmation: ["does not match confirmation"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{user: user} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Accounts.update_user_password(user, %{
          current_password: valid_user_password(),
          new_password: too_long,
          new_password_confirmation: too_long
        })

      assert "should be at most 72 character(s)" in errors_on(changeset).new_password
    end

    test "updates the password", %{user: user} do
      {:ok, {user, expired_tokens}} =
        Accounts.update_user_password(user, %{
          current_password: valid_user_password(),
          new_password: "new valid password",
          new_password_confirmation: "new valid password"
        })

      assert expired_tokens == []
      assert is_nil(user.new_password)
      assert Accounts.get_user_by_email_and_password(user.email, "new valid password")
    end

    test "deletes all tokens for the given user", %{user: user} do
      _ = Accounts.generate_user_session_token(user)

      {:ok, {_, _}} =
        Accounts.update_user_password(user, %{
          current_password: valid_user_password(),
          new_password: "new valid password",
          new_password_confirmation: "new valid password"
        })

      refute Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "generate_user_session_token/1" do
    setup do
      %{user: user_fixture()}
    end

    test "generates a token", %{user: user} do
      token = Accounts.generate_user_session_token(user)
      assert user_token = Repo.get_by(UserToken, token: token)
      assert user_token.context == "session"
      assert user_token.user_id == user.id

      # Creating the same token for another user should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%UserToken{
          token: user_token.token,
          user_id: user_fixture().id,
          context: "session"
        })
      end
    end

    test "creates a unique token for each session", %{user: user} do
      token = Accounts.generate_user_session_token(user)
      assert user_token = Repo.get_by(UserToken, token: token)
      assert user_token.inserted_at
    end
  end

  describe "get_user_by_session_token/1" do
    setup do
      user = user_fixture()
      token = Accounts.generate_user_session_token(user)
      %{user: user, token: token}
    end

    test "returns user by token", %{user: user, token: token} do
      assert {session_user, token_inserted_at} = Accounts.get_user_by_session_token(token)
      assert session_user.id == user.id
      assert token_inserted_at != nil
    end

    test "does not return user for invalid token" do
      refute Accounts.get_user_by_session_token("oops")
    end

    test "does not return user for expired token", %{token: token} do
      dt = ~N[2020-01-01 00:00:00]
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: dt])
      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "get_user_by_confirmation_token/1" do
    setup do
      user = unconfirmed_user_fixture()
      token = generate_user_confirmation_token(user)
      %{user: user, token: token}
    end

    test "returns user by token", %{user: user, token: token} do
      assert confirmation_user = Accounts.get_user_by_confirmation_token(token)
      assert confirmation_user.id == user.id
    end

    test "does not return user for invalid token" do
      refute Accounts.get_user_by_confirmation_token("oops")
    end

    test "does not return user for expired token", %{token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_user_by_confirmation_token(token)
    end
  end

  describe "confirm_user/1" do
    test "confirms user and expires tokens" do
      user = unconfirmed_user_fixture()
      refute user.confirmed_at
      encoded_token = generate_user_confirmation_token(user)

      assert {:ok, confirmed_user} = Accounts.confirm_user(encoded_token)

      assert confirmed_user.confirmed_at
      refute Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not confirm user for invalid token" do
      assert {:error, :invalid_token} = Accounts.confirm_user("oops")
    end

    test "does not confirm user for expired token" do
      user = unconfirmed_user_fixture()
      token = generate_user_confirmation_token(user)
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])

      assert {:error, :invalid_token} = Accounts.confirm_user(token)
      refute Accounts.get_user!(user.id).confirmed_at
    end

    test "does not reuse a confirmation token" do
      user = unconfirmed_user_fixture()
      token = generate_user_confirmation_token(user)
      assert {:ok, _confirmed_user} = Accounts.confirm_user(token)
      assert {:error, :invalid_token} = Accounts.confirm_user(token)
    end

    test "does not confirm if the user's email has changed" do
      user = unconfirmed_user_fixture()
      token = generate_user_confirmation_token(user)
      Repo.update!(Ecto.Changeset.change(user, email: "changed@example.com"))

      assert {:error, :invalid_token} = Accounts.confirm_user(token)
      refute Accounts.get_user!(user.id).confirmed_at
    end

    test "does not confirm an already confirmed user" do
      user = user_fixture()
      token = generate_user_confirmation_token(user)

      assert {:error, :invalid_token} = Accounts.confirm_user(token)
      assert Accounts.get_user!(user.id).confirmed_at
    end
  end

  describe "delete_user_session_token/1" do
    test "deletes the token" do
      user = user_fixture()
      token = Accounts.generate_user_session_token(user)
      assert Accounts.delete_user_session_token(token) == :ok
      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "deliver_user_confirmation_instructions/2" do
    setup do
      %{user: unconfirmed_user_fixture()}
    end

    test "sends token through notification", %{user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_confirmation_instructions(user, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert user_token = Repo.get_by(UserToken, token: :crypto.hash(:sha256, token))
      assert user_token.user_id == user.id
      assert user_token.sent_to == user.email
      assert user_token.context == "confirm"
    end
  end

  describe "inspect/2 for the User module" do
    test "does not include password" do
      refute inspect(%User{new_password: "123456"}) =~ "new_password: \"123456\""
    end
  end
end
