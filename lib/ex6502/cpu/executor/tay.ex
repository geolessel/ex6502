defmodule Ex6502.CPU.Executor.TAY do
  @moduledoc """
  Transfer the value of the a register to the y register

  ## Operation

  A -> Y

  ## Flags

  - Zero:     1 if y is zero; 0 otherwise
  - Negative: 1 if bit 7 of y is set; 0 otherwise
  """

  alias Ex6502.{Computer, CPU}

  def execute(%Computer{data_bus: 0xA8} = c) do
    c
    |> Map.put(:cpu, %{c.cpu | y: c.cpu.a})
    |> CPU.set_flags([:n, :z], :y)
    |> Computer.step_pc()
  end
end
