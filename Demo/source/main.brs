
sub Main()
    showChannelSGScreen()
end sub

sub showChannelSGScreen()
  screen = CreateObject("roSGScreen")
  m.port = CreateObject("roMessagePort")
  
  screen.setMessagePort(m.port)
  m.scene = screen.CreateScene("MainScene")
  screen.show()
  m.scene.observeField("outRequest", m.port)

  while(true)
    msg = wait(0, m.port)
    msgType = type(msg)
    if msgType = "roSGScreenEvent"
      if msg.isScreenClosed() then return
    else if msgType = "roSGNodeEvent"
      ' When The AppManager want to send command back to Main
      if msg.getField() = "outRequest"
        request = msg.getData()
        if request <> invalid
          if request.DoesExist("ExitApp") and (request.ExitApp = true)
              screen.close()
          end if
        end if
      end if
    end if
  end while
end sub
