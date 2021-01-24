defmodule Ex6502.CPU.Executor.PLXTest do
  use ExUnit.Case, async: true

  alias Ex6502.{Computer, CPU, Memory}
  alias Ex6502.CPU.Executor.PLX

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "PLX" do
    test "$fa", %{c: c} do
      c =
        c
        |> setup_computer_for(0xFA)
        |> Computer.load(0x8000, [0xFA])
        |> Computer.load(0x01FF, [0x99])
        |> CPU.set(:sp, 0xFE)
        |> CPU.set(:x, 0x00)
        |> PLX.execute()

      assert c.cpu.sp == 0xFF
      assert c.cpu.pc == 0x8001
      assert c.cpu.x == 0x99
    end
  end

  def setup_computer_for(c, data) do
    c
    |> Map.put(:data_bus, data)
    |> Map.put(:cpu, Map.update(c.cpu, :pc, 0, &(&1 + 1)))
  end
end
