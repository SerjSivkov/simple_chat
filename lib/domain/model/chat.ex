defmodule SimpleChat.Domain.Model.Chat do
  @moduledoc false

  alias SimpleChat.Domain.Service.ChatUsers, as: ChatUsersService
  alias SimpleChat.Domain.Model.User

  @type chat :: %__MODULE__{}

  defstruct name: nil, id: nil

  @chat_user_service ChatUsersService

  @spec new(any) :: __MODULE__.chat()
  def new(name), do: %__MODULE__{name: name, id: generate_id()}

  @spec get_users(__MODULE__.chat()) :: []
  def get_users(%__MODULE__{id: id}), do: @chat_user_service.get_users_in_chat(id)

  @spec join_chat(User.user()) :: {:ok, true} | {:error, binary()}
  def join_chat(%User{} = user), do: @chat_user_service.add_user_to_chat(user)

  @spec leave_chat(User.user()) :: {:ok, true} | {:error, binary()}
  def leave_chat(%User{} = user), do: @chat_user_service.remove_user_from_chat(user)

  defp generate_id() do
    datetime = NaiveDateTime.local_now()
    |> NaiveDateTime.to_iso8601()

    :crypto.hash(:md5, datetime)
    |> Base.encode16()
  end
end
