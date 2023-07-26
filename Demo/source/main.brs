
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
    m.scene.setFocus(true)
    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed()
                return
            end if
        else if msgType = "roSGNodeEvent"
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
