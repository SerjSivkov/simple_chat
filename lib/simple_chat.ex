defmodule SimpleChat do
  @moduledoc false

  import SimpleChat.Infrastructure.Repository.Base,
    only: [chat_users_table: 0, chats_table: 0, user_chats_table: 0, users_table: 0]

  alias SimpleChat.Infrastructure.Service.Message, as: MessageService

  @tables [
    chat_users_table(),
    chats_table(),
    user_chats_table(),
    users_table()
  ]

  # FOR TEST
  @spec new_user(atom | pid | port | {atom, atom}, String.t()) :: atom | pid | port | {atom, atom}
  def new_user(pid, login) do
    send(pid, {:new_user, login})
    pid
  end

  @spec new_chat(atom | pid | port | {atom, atom}, String.t()) :: atom | pid | port | {atom, atom}
  def new_chat(pid, name) do
    send(pid, {:new_chat, name})
    pid
  end

  @spec join_chat(atom | pid | port | {atom, atom}, String.t(), String.t()) ::
          atom | pid | port | {atom, atom}
  def join_chat(pid, user_login, chat_id) do
    send(pid, {:join_chat, user_login, chat_id})
    pid
  end

  @spec send_message(atom | pid | port | {atom, atom}, String.t(), String.t(), String.t()) ::
          atom | pid | port | {atom, atom}
  def send_message(pid, message, chat_id, from_user_login) do
    send(pid, {:send_message_to_chat, message, chat_id, from_user_login})
    pid
  end

  def test_it do
    pid = run()
    new_chat(pid, "test_chat")
    :timer.sleep(200)

    new_user(pid, "test_user1")
    :timer.sleep(200)
    new_user(pid, "test_user2")
    :timer.sleep(200)

    join_chat(pid, "test_user1", :ets.first(:chats))
    :timer.sleep(200)
    join_chat(pid, "test_user2", :ets.first(:chats))
    :timer.sleep(200)

    send_message(pid, "test message", :ets.first(:chats), "test_user1")
  end

  @spec run :: no_return
  def run() do
    Enum.each(@tables, &init_table/1)

    spawn_link(__MODULE__, :loop, []) # В отдельном процессе
  end

  @spec loop :: no_return
  def loop() do
    receive do
      msg -> MessageService.handle_message(msg)
    end

    loop()
  end

  defp init_table(name) do
    :ets.new(name, [:public, :named_table, :set])
  end
end
