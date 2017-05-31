defmodule Issues.TableFormatter do

  def print_table_for_columns(rows, headers) do
    with data_by_columns = split_into_columns(rows, headers),
         column_widths   = widths_of(data_by_columns),
         format          = format_for(column_widths)
    do
         puts_one_line_in_columns(headers, format)
         IO.puts(separator(column_widths))
         puts_in_columns(data_by_columns, format)
    end
  end

  def split_into_columns(rows, headers) do
    Enum.map(headers, fn header ->
      Enum.map(rows, fn row -> printable(row[header]) end)
    end)
  end

  def widths_of(columns) do
    Enum.map(columns, fn column ->
      column
      |> Enum.map(&String.length/1)
      |> Enum.max
    end)
  end

  def format_for(column_widths) do
    Enum.map_join(column_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  def separator(column_widths) do
    Enum.map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
  end

  def puts_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.each(&puts_one_line_in_columns(&1, format))
  end

  def puts_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end

  defp printable(str) when is_binary(str), do: str
  defp printable(str), do: to_string(str)
end
