defmodule SalvaCompra.Format.Dinheiro do
  import Number.Currency

  def integer_to_dinheiro(integer) do
    digits = Integer.digits(integer)

    decimals =
      Enum.reverse(digits)
      |> Enum.split(2)
      |> case do
        {values, _} -> values
      end
      |> Integer.undigits()

    integers = Enum.drop(digits, -2) |> Integer.undigits()
    {result, _} = Float.parse("#{integers}.#{decimals}")
    result
  end

  def format_to_display(integer) do
    integer_to_dinheiro(integer)
    |> number_to_currency(
      unit: "R$",
      delimiter: ".",
      separator: ",",
      precision: 2
    )
  end
end
