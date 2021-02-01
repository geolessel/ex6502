defmodule Ex6502.CPU.Executor.Branching do
  alias Ex6502.{Computer, CPU}

  def branch(%Computer{} = c, true) do
    with %Computer{data_bus: address} = c <- Computer.put_next_byte_on_data_bus(c) do
      <<offset::signed-integer-8>> = <<address::integer-8>>
      CPU.set(c, :pc, c.cpu.pc + offset)
    end
  end

  def branch(%Computer{} = c, false), do: Computer.put_next_byte_on_data_bus(c)
end
