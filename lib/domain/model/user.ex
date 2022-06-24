defmodule SimpleChat.Domain.Model.User do
  @moduledoc false

  alias SimpleChat.Domain.Service.ChatUsers, as: ChatUsersService

  @type t :: %__MODULE__{}

  defstruct login: nil

  @chat_users_service ChatUsersService

  @spec new(String.t()) :: __MODULE__.user()
  def new(login), do: %__MODULE__{login: login}

  @spec get_chats(__MODULE__.user()) :: []
  def get_chats(%__MODULE__{login: login}), do: @chat_users_service.get_user_chats(login)
end
