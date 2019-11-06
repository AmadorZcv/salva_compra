defmodule SalvaCompra.Format.Dinheiro do
  def format_to_display(integer) do
    Money.new(integer, :BRL)
    |> Money.to_string(
      delimiter: ".",
      separator: ","
    )
  end
end
