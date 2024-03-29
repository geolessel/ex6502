defmodule Ex6502.CPU.Executor.TSX do
  @moduledoc """
  Transfer the value of the stack pointer to the x register

  ## Operation

  SP -> X

  ## Flags

  - Zero:     1 if x is zero; 0 otherwise
  - Negative: 1 if bit 7 of x is set; 0 otherwise
  """

  alias Ex6502.{Computer, CPU}

  def execute(%Computer{data_bus: 0xBA} = c) do
    c
    |> Map.put(:cpu, %{c.cpu | x: c.cpu.sp})
    |> CPU.set_flags([:n, :z], :x)
  end
end
