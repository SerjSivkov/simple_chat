defmodule SimpleChat.Infrastructure.Repository.UserChats do
  import SimpleChat.Infrastructure.Repository.Base
  alias SimpleChat.Domain.Model.User, as: UserModel
  alias SimpleChat.Infrastructure.Repository.User

  @table user_chats_table()

  @spec add_chat(UserModel.t(), binary()) :: :ok | {:error, :not_found}
  def add_chat(%UserModel{login: login}, chat_id) do
    with {:ok, _user} <- User.get(login),
         true <- :ets.lookup(@table, login)
                 |> add_chat_to_user(login, chat_id)
    do
      :ok
    end
  end

  @spec remove_chat(UserModel.t(), binary()) :: true
  def remove_chat(%UserModel{login: login}, chat_id) do
    case get(login) do
      {:ok, chats} ->
        new_chats = Enum.filter(chats, &(&1 != chat_id))
        :ets.insert(@table, {login, new_chats})
    end
  end

  @spec get(binary()) :: {:error, :not_found} | {:ok, [Chat.t(), ...]}
  def get(login) do
    :ets.lookup(@table, login) |> result_or_error()
  end

  defp add_chat_to_user([], login, chat_id) do
    :ets.insert(@table, {login, [chat_id]})
  end

  defp add_chat_to_user([{_, chat_ids}], login, chat_id) do
    :ets.insert(@table, {login, [chat_id | chat_ids]})
  end
end
