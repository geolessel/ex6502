defmodule Ex6502.CPU.Executor.STA do
  alias Ex6502.{Computer, CPU, Memory}

  # Absolute (STA $nnnn)
  def execute(%Computer{data_bus: 0x8D} = c) do
    with c <- Computer.put_absolute_address_on_bus(c) do
      Computer.load(c, c.address_bus, [c.cpu.a])
    end
  end

  # X-indexed absolute (STA $nnnn,X)
  def execute(%Computer{data_bus: 0x9D} = c) do
    with c <- Computer.put_absolute_address_on_bus(c) do
      Computer.load(c, c.address_bus + c.cpu.x, [c.cpu.a])
    end
  end

  # Y-indexed absolute (STA $nnnn,Y)
  def execute(%Computer{data_bus: 0x99} = c) do
    with c <- Computer.put_absolute_address_on_bus(c) do
      Computer.load(c, c.address_bus + c.cpu.y, [c.cpu.a])
    end
  end

  # Zero page (STA $nn)
  def execute(%Computer{data_bus: 0x85} = c) do
    with c <-
           c
           |> Computer.put_zero_page_on_address_bus()
           |> Memory.absolute() do
      Computer.load(c, c.address_bus, [c.cpu.a])
    end
  end

  # X-indexed zero page (STA $nn,X)
  def execute(%Computer{data_bus: 0x95} = c) do
    with c <- Computer.put_zero_page_on_address_bus(c) do
      Computer.load(c, c.address_bus + c.cpu.x, [c.cpu.a])
    end
  end

  # zero page indirect (STA ($nn))
  def execute(%Computer{data_bus: 0x92} = c) do
    with c <-
           c
           |> Computer.put_zero_page_on_address_bus()
           |> Memory.indirect() do
      Computer.load(c, c.address_bus, [c.cpu.a])
    end
  end

  # x-indexed zero page indirect (STA ($nn,X))
  def execute(%Computer{data_bus: 0x81} = c) do
    with c <-
           c
           |> Computer.put_zero_page_on_address_bus()
           |> Memory.indirect(c.cpu.x) do
      Computer.load(c, c.address_bus, [c.cpu.a])
    end
  end

  # zero page indirect y-indexed (STA ($nn),Y)
  def execute(%Computer{data_bus: 0x91} = c) do
    with c <-
           c
           |> Computer.put_zero_page_on_address_bus(c.cpu.y)
           |> Memory.indirect() do
      Computer.load(c, c.address_bus, [c.cpu.a])
    end
  end
end
