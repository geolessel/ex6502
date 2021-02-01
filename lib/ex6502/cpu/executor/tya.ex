defmodule Ex6502.CPU.Executor.TYA do
  @moduledoc """
  Transfer the value of the Y register to the accumulator

  ## Operation

  Y -> A

  ## Flags

  - Zero:     1 if Y is zero; 0 otherwise
  - Negative: 1 if bit 7 of Y is set; 0 otherwise
  """

  alias Ex6502.{Computer, CPU}

  def execute(%Computer{data_bus: 0x98} = c) do
    c
    |> Map.put(:cpu, %{c.cpu | a: c.cpu.y})
    |> CPU.set_flags([:n, :z], :a)
  end
end
