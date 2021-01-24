defmodule Ex6502.CPU.Executor.PHPTest do
  use ExUnit.Case, async: true

  alias Ex6502.{Computer, CPU, Memory}
  alias Ex6502.CPU.Executor.PHP

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "PHP" do
    test "$08", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0x08])
        |> setup_computer_for(0x08)
        |> CPU.set(:p, 0x99)
        |> PHP.execute()

      assert c.cpu.sp == 0xFE
      assert c.cpu.pc == 0x8001
      assert Memory.get(c.memory, 0x01FF) == 0x99
    end
  end

  def setup_computer_for(c, data) do
    c
    |> Map.put(:data_bus, data)
    |> Map.put(:cpu, Map.update(c.cpu, :pc, 0, &(&1 + 1)))
  end
end
