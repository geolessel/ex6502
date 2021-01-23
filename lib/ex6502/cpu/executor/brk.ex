defmodule Ex6502.CPU.Executor.BRK do
  alias Ex6502.{Computer, CPU}

  def execute(%Computer{data_bus: 0x00} = c) do
    Mix.Shell.IO.error("BRK TODO: set interrupt flag, set stack")

    c
    |> CPU.set_flag(:i, true)
    |> Map.put(:running, false)
  end
end
