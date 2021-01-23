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

  alias Ex6502.{Computer, CPU, Memory}

  def execute(%Computer{} = c) do
    c
    |> do_execute()
    |> CPU.set_flags([:n, :z], :a)
  end

  # LDA Immediate (LDA #$nn)
  def do_execute(%Computer{data_bus: 0xA9} = c) do
    c
    |> Computer.put_next_byte_on_data_bus()
    |> CPU.set(:a)
  end

  # LDA Absolute (LDA $nnnn)
  def do_execute(%Computer{data_bus: 0xAD} = c) do
    c
    |> Computer.put_absolute_address_on_bus()
    |> Memory.absolute()
    |> CPU.set(:a)
  end

  # X-indexed absolute (LDA $nnnn,X)
  def do_execute(%Computer{data_bus: 0xBD} = c) do
    c
    |> Computer.put_absolute_address_on_bus()
    |> Memory.absolute(c.cpu.x)
    |> CPU.set(:a)
  end

  # Y-Indexed absolute (LDA $nnnn,Y)
  def do_execute(%Computer{data_bus: 0xB9} = c) do
    c
    |> Computer.put_absolute_address_on_bus()
    |> Memory.absolute(c.cpu.y)
    |> CPU.set(:a)
  end

  # zero-page
  def do_execute(%Computer{data_bus: 0xA5} = c) do
    c
    |> Computer.put_zero_page_on_address_bus()
    |> Memory.absolute()
    |> CPU.set(:a)
  end

  # x-indexed zero-page
  def do_execute(%Computer{data_bus: 0xB5} = c) do
    c
    |> Computer.put_zero_page_on_address_bus()
    |> Memory.absolute(c.cpu.x)
    |> CPU.set(:a)
  end

  # zero-page indirect
  def do_execute(%Computer{data_bus: 0xB2} = c) do
    c
    |> Computer.put_zero_page_on_address_bus()
    |> Memory.indirect()
    |> CPU.set(:a)
  end

  # x-indexed zero page indirect
  def do_execute(%Computer{data_bus: 0xA1} = c) do
    c
    |> Computer.put_zero_page_on_address_bus()
    |> Memory.indirect(c.cpu.x)
    |> CPU.set(:a)
  end

  # zero-page indirect y-indexed
  def do_execute(%Computer{data_bus: 0xB1} = c) do
    c
    |> Computer.put_zero_page_on_address_bus(c.cpu.y)
    |> Memory.indirect()
    |> CPU.set(:a)
  end
end
