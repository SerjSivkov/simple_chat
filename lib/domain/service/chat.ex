defmodule SimpleChat.Domain.Service.Chat do
  alias SimpleChat.Domain.Model.Chat, as: ChatModel
  alias SimpleChat.Infrastructure.Repository.Chat, as: ChatRepo

  @spec add(binary()) :: true
  def add(name) do
    name
    |> ChatModel.new()
    |> ChatRepo.new()
  end

  @spec delete(ChatModel.t()) :: true
  def delete(%ChatModel{id: id}), do ChatRepo.delete(id)
end
