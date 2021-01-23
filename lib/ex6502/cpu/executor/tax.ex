defmodule Ex6502.CPU.Executor.TAX do
  @moduledoc """
  Transfer the value of the a register to the x register

  ## Operation

  A -> X

  ## Flags

  - Zero:     1 if x is zero; 0 otherwise
  - Negative: 1 if bit 7 of x is set; 0 otherwise
  """

  alias Ex6502.{Computer, CPU}

  def execute(%Computer{data_bus: 0xAA} = c) do
    c
    |> Map.put(:cpu, %{c.cpu | x: c.cpu.a})
    |> CPU.set_flags([:n, :z], :x)
    |> Computer.step_pc()
  end
end
