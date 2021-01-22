defmodule Ex6502.CPU.Executor.LDY do
  @moduledoc """
  Load register y from memory

  ## Operation

  M -> Y

  Load data from memory into the y register.

  ## Flags

  - Zero:     1 if register y is zero; 0 otherwise
  - Negative: 1 if bit 7 of register y is set; 0 otherwise
  """

  alias Ex6502.{CPU, Memory}
  import Ex6502.CPU.Executor.LD, only: [set_flags: 1]

  use Bitwise

  # LDY Immediate (LDY #$nn)
  def execute(0xA0) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.get()

    CPU.set(:y, value)
    CPU.advance_pc(2)
    set_flags(value)
  end

  # LDY absolute (LDY #nnnn)
  def execute(0xAC) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.absolute()

    CPU.set(:y, value)
    CPU.advance_pc(3)
    set_flags(value)
  end

  # LDY x-indexed absolute (LDY $nnnn,X)
  def execute(0xBC) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.absolute(CPU.get(:x))

    CPU.set(:y, value)
    CPU.advance_pc(3)
    set_flags(value)
  end

  # LDY zero page (LDY $nn)
  def execute(0xA4) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.zero_page()

    CPU.set(:y, value)
    CPU.advance_pc(2)
    set_flags(value)
  end

  # LDY x-indexed zero page (LDY $nn,X)
  def execute(0xB4) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.zero_page(CPU.get(:x))

    CPU.set(:y, value)
    CPU.advance_pc(2)
    set_flags(value)
  end
end
