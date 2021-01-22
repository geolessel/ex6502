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

  alias Ex6502.{Computer, CPU, Memory}

  use Bitwise

  def execute(%Computer{} = c) do
    c
    |> do_execute()
    |> CPU.set(:y)
    |> CPU.set_flags([:n, :z], :y)
  end

  # LDY Immediate (LDY #$nn)
  def do_execute(%Computer{data_bus: 0xA0} = c) do
    c
    |> Computer.put_next_byte_on_data_bus()
  end

  # LDY absolute (LDY #nnnn)
  def do_execute(%Computer{data_bus: 0xAC} = c) do
    c
    |> Computer.put_absolute_address_on_bus()
    |> Memory.absolute()
  end

  # LDY x-indexed absolute (LDY $nnnn,X)
  def do_execute(%Computer{data_bus: 0xBC} = c) do
    c
    |> Computer.put_absolute_address_on_bus()
    |> Memory.absolute(c.cpu.x)
  end

  # LDY zero page (LDY $nn)
  def do_execute(%Computer{data_bus: 0xA4} = c) do
    c
    |> Computer.put_zero_page_on_address_bus()
    |> Memory.absolute()
  end

  # LDY x-indexed zero page (LDY $nn,X)
  def do_execute(%Computer{data_bus: 0xB4} = c) do
    c
    |> Computer.put_zero_page_on_address_bus()
    |> Memory.absolute(c.cpu.x)
  end
end
