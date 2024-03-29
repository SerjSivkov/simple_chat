defmodule SimpleChat.Infrastructure.Repository.ChatUsers do
  import SimpleChat.Infrastructure.Repository.Base, only: [chat_users_table: 0]

  @table chat_users_table()

  import SimpleChat.Infrastructure.Repository.Base
  alias SimpleChat.Domain.Model.User

  @spec add_user(User.t(), binary()) :: :ok | {:error, :not_found}
  def add_user(%User{login: login}, chat_id) do
    :ets.lookup(@table, chat_id)
    |> add_user_to_chat(chat_id, login)

    :ok
  end

  @spec remove_user(User.t(), binary()) :: true
  def remove_user(%User{login: login}, chat_id) do
    case get(chat_id) do
      {:ok, users} ->
        new_users = Enum.filter(users, &(&1 != login))

        :ets.insert(@table, {chat_id, new_users})

      _ -> true
    end
  end

  @spec get(binary()) :: {:error, :not_found} | {:ok, [User.t(), ...]}
  def get(chat_id) do
    :ets.lookup(@table, chat_id) |> result_or_error()
  end

  defp add_user_to_chat([], chat_id, user_login) do
    :ets.insert(@table, {chat_id, [user_login]})
  end

  defp add_user_to_chat([{_, user_logins}], chat_id, user_login) do
    :ets.insert(@table, {chat_id, [user_login | user_logins]})
  end
end
