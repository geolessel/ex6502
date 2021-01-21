defmodule Ex6502.CPU.Executor.LDA do
  @moduledoc """
  ## Operation

  M -> A

  Transfer data from memory to the accumulator.

  ## Flags

  - Negative: 1 if bit 7 of accumulator is set, 0 otherwise
  - Zero:     1 if accumulator is zero, 0 otherwise
  """

  alias Ex6502.{CPU, Memory}

  use Bitwise

  # LDA Immediate (LDA #$nn)
  def execute(0xA9) do
    pc = CPU.get(:pc)
    value = Memory.get(pc + 1)

    CPU.set(:a, value)
    CPU.advance_pc(2)
    set_flags(value)
  end

  # LDA Absolute (LDA $nnnn)
  def execute(0xAD) do
    value = Memory.absolute(CPU.get(:pc) + 1)

    CPU.set(:a, value)
    CPU.advance_pc(3)
    set_flags(value)
  end

  # X-indexed absolute
  def execute(0xBD) do
    value = Memory.absolute(CPU.get(:pc) + 1, CPU.get(:x))

    CPU.set(:a, value)
    CPU.advance_pc(3)
    set_flags(value)
  end

  # Y-Indexed absolute
  def execute(0xB9) do
    value = Memory.absolute(CPU.get(:pc) + 1, CPU.get(:y))

    CPU.set(:a, value)
    CPU.advance_pc(3)
    set_flags(value)
  end

  # zero-page
  def execute(0xA5) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.get()
      |> Memory.get()

    CPU.set(:a, value)
    CPU.advance_pc(2)
    set_flags(value)
  end

  # x-indexed zero-page
  def execute(0xB5) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.get()
      |> Kernel.+(CPU.get(:x))
      |> Memory.get()

    CPU.set(:a, value)
    CPU.advance_pc(2)
    set_flags(value)
  end

  # zero-page indirect
  def execute(0xB2) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.get()
      |> Memory.absolute()

    CPU.set(:a, value)
    CPU.advance_pc(2)
    set_flags(value)
  end

  # x-indexed zero page indirect
  def execute(0xA1) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.get()
      |> Memory.absolute(CPU.get(:x))

    CPU.set(:a, value)
    CPU.advance_pc(2)
    set_flags(value)
  end

  # zero-page indirect y-indexed
  def execute(0xB1) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.get()
      |> Kernel.+(CPU.get(:y))
      |> Memory.absolute()

    CPU.set(:a, value)
    CPU.advance_pc(2)
    set_flags(value)
  end

  defp set_flags(value) do
    # is bit 7 a 1?
    CPU.set_flag(:n, (value &&& 1 <<< 7) >>> 7)
    CPU.set_flag(:z, value == 0)
  end
end
