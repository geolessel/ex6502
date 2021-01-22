defmodule Ex6502.CPU.Executor.LDA do
  @moduledoc """
  Load accumulator (register a) from memory

  ## Operation

  M -> A

  Load data from memory to the accumulator.

  ## Flags

  - Zero:     1 if accumulator is zero; 0 otherwise
  - Negative: 1 if bit 7 of accumulator is set; 0 otherwise
  """

  alias Ex6502.{CPU, Memory}
  import Ex6502.CPU.Executor.LD, only: [set_flags: 1]

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
      |> Memory.zero_page()

    CPU.set(:a, value)
    CPU.advance_pc(2)
    set_flags(value)
  end

  # x-indexed zero-page
  def execute(0xB5) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.zero_page(CPU.get(:x))

    CPU.set(:a, value)
    CPU.advance_pc(2)
    set_flags(value)
  end

  # zero-page indirect
  def execute(0xB2) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.indirect()

    CPU.set(:a, value)
    CPU.advance_pc(2)
    set_flags(value)
  end

  # x-indexed zero page indirect
  def execute(0xA1) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.indirect(post_index: CPU.get(:x))

    CPU.set(:a, value)
    CPU.advance_pc(2)
    set_flags(value)
  end

  # zero-page indirect y-indexed
  def execute(0xB1) do
    value =
      (CPU.get(:pc) + 1)
      |> Memory.indirect(pre_index: CPU.get(:y))

    CPU.set(:a, value)
    CPU.advance_pc(2)
    set_flags(value)
  end
end
