defmodule SimpleChat.Domain.Model.Chat do
  @moduledoc false

  alias SimpleChat.Domain.Service.ChatUsers, as: ChatUsersService
  alias SimpleChat.Domain.Model.User

  @type t :: %__MODULE__{}

  defstruct name: nil, id: nil

  @chat_users_service ChatUsersService

  @spec new(String.t()) :: __MODULE__.t()
  def new(name), do: %__MODULE__{name: name, id: generate_id()}

  @spec get_users(__MODULE__.t()) :: {:error, :not_found} | {:ok, [SimpleChat.Domain.Model.User.t(), ...]}
  def get_users(%__MODULE__{id: id}), do: @chat_users_service.get_users_in_chat(id)

  @spec join_chat(binary(), binary) :: :ok | {:error, :not_found}
  def join_chat(user_login, chat_id), do: @chat_users_service.add_user_to_chat(user_login, chat_id)

  @spec leave_chat(binary(), binary) :: true
  def leave_chat(user_login, chat_id), do: @chat_users_service.remove_user_from_chat(user_login, chat_id)

  defp generate_id() do
    datetime =
      NaiveDateTime.local_now()
      |> NaiveDateTime.to_iso8601()

    :crypto.hash(:md5, datetime)
    |> Base.encode16()
  end
end
