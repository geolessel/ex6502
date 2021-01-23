defmodule Ex6502.CPU.Executor.TXS do
  @moduledoc """
  Transfer the value of the x register to the stack pointer

  ## Operation

  X -> SP

  ## Flags

  No flags are affected
  """

  alias Ex6502.Computer

  def execute(%Computer{data_bus: 0x9A} = c) do
    c
    |> Map.put(:cpu, %{c.cpu | sp: c.cpu.x})
    |> Computer.step_pc()
  end
end
