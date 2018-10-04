defmodule Slogger.Table do
  require Slogger

  @spec name() ::atom()
  def name() do
    Application.get_env(:slogger, :levels_table_name) || :slogger_levels_table
  end

  @spec start() :: atom()
  def start() do
    try do
      :ets.new(name(), [:named_table, :public, read_concurrency: true])
      :ok
    rescue ArgumentError ->
      {:error, :already_started}
    end
  end

  @spec exists?() :: boolean()
  def exists?() do
    name()
    |> :ets.info(:id)
    |> is_reference()
  end

  @spec set_level(any(), :debug | :error | :info | :warn) :: :ok
  def set_level(key, value) when Slogger.is_level(value) do
    if not exists?() do
      start()
    end
    :ets.insert(name(), {key, value})
    :ok
  end

  @spec get_level(any()) :: atom()
  def get_level(key) do
    if exists?() do
      name()
      |> :ets.lookup(key)
      |> case do
        [{^key, level}] ->
          level
        _ ->
          nil
      end
    end
  end
end
