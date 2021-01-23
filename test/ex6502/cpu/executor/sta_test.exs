defmodule Ex6502.CPU.Executor.STATest do
  use ExUnit.Case, async: true
  alias Ex6502.CPU.Executor.STA
  alias Ex6502.{Computer, CPU, Memory}

  setup do
    m =
      Memory.init(0xFFFF)
      |> Memory.set_reset_vector(0x8000)

    c = Computer.init(memory: m)

    %{c: c}
  end

  describe "STA" do
    test "$8D absolute [STA $nnnn]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0x8D, 0x50, 0x85])
        |> setup_computer_for(0x8D)
        |> CPU.set(:a, 0x99)
        |> STA.execute()

      assert Memory.get(c.memory, 0x8550) == 0x99
      assert c.cpu.pc == 0x8003
    end

    test "$9D x-indexed absolute [STA $nnnn,X]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0x9D, 0x50, 0x85])
        |> setup_computer_for(0x9D)
        |> CPU.set(:x, 0x05)
        |> CPU.set(:a, 0x99)
        |> STA.execute()

      assert Memory.get(c.memory, 0x8555) == 0x99
      assert c.cpu.pc == 0x8003
    end

    test "$99 y-indexed absolute [STA $nnnn,Y]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0x99, 0x50, 0x85])
        |> setup_computer_for(0x99)
        |> CPU.set(:y, 0x05)
        |> CPU.set(:a, 0x99)
        |> STA.execute()

      assert Memory.get(c.memory, 0x8555) == 0x99
      assert c.cpu.pc == 0x8003
    end

    test "$85 zero page [STA $nn]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0x85, 0x50])
        |> setup_computer_for(0x85)
        |> CPU.set(:a, 0x99)
        |> STA.execute()

      assert Memory.get(c.memory, 0x0050) == 0x99
      assert c.cpu.pc == 0x8002
    end

    test "$95 x-indexed zero page [STA $nn,X]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0x95, 0x02])
        |> setup_computer_for(0x95)
        |> CPU.set(:x, 0x05)
        |> CPU.set(:a, 0x99)
        |> STA.execute()

      assert Memory.get(c.memory, 0x0007) == 0x99
      assert c.cpu.pc == 0x8002
    end

    test "$92 zero page indirect [STA ($nn)]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0x92, 0x50])
        |> Computer.load(0x0050, [0x10, 0x90])
        |> setup_computer_for(0x92)
        |> CPU.set(:a, 0x99)
        |> STA.execute()

      assert Memory.get(c.memory, 0x9010) == 0x99
      assert c.cpu.pc == 0x8002
    end

    test "$81 x-indexed zero page indirect [STA ($nn,X)]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0x81, 0x50])
        |> Computer.load(0x0050, [0x10, 0x90])
        |> setup_computer_for(0x81)
        |> CPU.set(:x, 0x05)
        |> CPU.set(:a, 0x99)
        |> STA.execute()

      assert Memory.get(c.memory, 0x9015) == 0x99
      assert c.cpu.pc == 0x8002
    end

    test "$91 zero page indirect y-indexed [STA ($nn),Y]", %{c: c} do
      c =
        c
        |> Computer.load(0x8000, [0x91, 0x50])
        |> Computer.load(0x0055, [0x10, 0x90])
        |> setup_computer_for(0x91)
        |> CPU.set(:y, 0x05)
        |> CPU.set(:a, 0x99)
        |> STA.execute()

      assert Memory.get(c.memory, 0x9010) == 0x99
      assert c.cpu.pc == 0x8002
    end
  end

  def setup_computer_for(c, data) do
    c
    |> Map.put(:data_bus, data)
    |> Map.put(:cpu, Map.update(c.cpu, :pc, 0, &(&1 + 1)))
  end
end
