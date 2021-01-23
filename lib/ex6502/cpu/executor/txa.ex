defmodule Ex6502.CPU.Executor.TXA do
  @moduledoc """
  Transfer the value of the x register to the accumulator

  ## Operation

  X -> A

  ## Flags

  - Zero:     1 if A is zero; 0 otherwise
  - Negative: 1 if bit 7 of A is set; 0 otherwise
  """

  alias Ex6502.{Computer, CPU}

  def execute(%Computer{data_bus: 0x8A} = c) do
    c
    |> Map.put(:cpu, %{c.cpu | a: c.cpu.x})
    |> CPU.set_flags([:n, :z], :a)
    |> Computer.step_pc()
  end
end
