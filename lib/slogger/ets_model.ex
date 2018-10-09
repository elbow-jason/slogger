defmodule Slogger.EtsModel do

  defmacro __using__(fields) do
    quote do

      @fields unquote(fields)

      defstruct @fields

      @indexed_fields @fields |> Keyword.keys() |> Enum.with_index()

      @ms_defaults Enum.map(@indexed_fields, fn {k, i} -> {k, :"$#{i + 1}"} end)

      def to_match_spec(kwargs) when is_list(kwargs) do
        @ms_defaults
        |> Enum.map(fn {k, default} -> Keyword.get(kwargs, k, default) end)
        |> List.to_tuple()
      end

      def to_element_spec(%__MODULE__{} = entry) do
        entry
        |> Map.from_struct()
        |> to_element_spec()
      end

      def to_element_spec(%{} = map) do
        map
        |> Enum.into([])
        |> to_element_spec()
      end

      def to_element_spec(kwargs) when is_list(kwargs) do
        Enum.reduce(@indexed_fields, [], fn {k, pos}, acc ->
          case Keyword.fetch(kwargs, k) do
            {:ok, value} ->
              [{pos, value} | acc]
            :error ->
              acc
          end
        end)
      end

      def from_ets_tuple(row) when is_tuple(row) do
        data = Enum.map(@indexed_fields, fn {k, i} -> {k, elem(row, i)} end)
        struct!(__MODULE__, data)
      end

      def to_ets_tuple(%__MODULE__{} = struct_map) do
        struct_map
        |> Map.from_struct()
        |> to_ets_tuple()
      end

      def to_ets_tuple(row) when is_list(row) or is_map(row) do
        @fields
        |> Enum.map(fn {k, v} -> Keyword.get(row, k, v) end)
        |> List.to_tuple()
      end
    end
  end
end
