defmodule Slogger.Table do
  require Slogger
  alias Slogger.State

  @spec name() ::atom()
  def name() do
    Application.get_env(:slogger, :levels_table_name) || :slogger_levels_table
  end

  @spec start() :: atom()
  def start() do
    try do
      :ets.new(name(), [:set, :named_table, :public, read_concurrency: true])
      :ok
    rescue ArgumentError ->
      {:error, :already_started}
    end
  end

  def upsert(%State{} = state) do
    state
    |> Map.from_struct()
    |> Enum.into([])
    |> upsert
  end

  def upsert(kwargs) when is_list(kwargs) do
    ets_row = State.to_ets_tuple(kwargs)
    if :ets.insert_new(name(), ets_row) do
      :ok
    else
      {module, updates} = Keyword.pop_lazy(kwargs, :module, &raise_module_required/0)
      element_spec = State.to_element_spec(updates)
      :ets.update_element(name(), module, element_spec)
      :ok
    end
  end

  defp raise_module_required() do
    raise ArgumentError, message: ":module is required to upsert new :ets row"
  end

  def fetch(module) do
    name()
    |> :ets.lookup(module)
    |> case do
      [item] when is_tuple(item) ->
        {:ok, State.from_ets_tuple(item)}
      _ ->
        :error
    end
  end

  def get_by(kwargs) do
    :ets.match_object(name(), State.to_match_spec(kwargs))
  end

  def info() do
    :ets.info(name())
  end
end
