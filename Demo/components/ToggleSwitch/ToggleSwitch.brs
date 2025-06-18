sub init()
    print "ToggleSwitch : Init"
    SetControls()
    SetupFonts()
    SetupColors()
    SetControls()
    SetObservers()
end sub

sub SetControls()
    m.turnOn = m.top.findNode("turnOn")
    m.turnOff = m.top.findNode("turnOff")
    m.rightText = m.top.findNode("rightText")
    m.leftText = m.top.findNode("leftText")
    m.toggleOnAnimation = m.top.findNode("toggleOnAnimation")
    m.toggleOffAnimation = m.top.findNode("toggleOffAnimation")
    m.maskGrp = m.top.findNode("maskGrp")
    m.pToggleBox = m.top.findNode("pToggleBox")

    roDeviceInfo = CreateObject("roDeviceInfo")
    designResolution = roDeviceInfo.GetDisplayMode()
    maskSize = [1620,100]
    if designresolution = "720p"
        maskSize = [maskSize[0] /1.5,maskSize[1]/1.5]
    end if
    m.maskGrp.maskSize = maskSize

    m.turnOn.visible = false
    m.turnOff.visible = true

    if m.turnOn.visible
        m.leftText.color = "#000000"
        m.rightText.color = "#FFFFFF"
    else
        m.rightText.color = "#FFFFFF"
        m.leftText.color = "#000000"
    end if
end sub

sub SetupFonts()
end sub

sub SetupColors()
    m.turnOff.blendColor = "#FFFFFF"
    m.turnOn.blendColor = "#FFFFFF"
end sub

sub SetObservers()
    m.top.observeField("focusedChild","OnFocusedChild")
end sub

function OnFocusedChild()
      if m.top.hasFocus() or m.top.IsInFocusChain()
          m.turnOff.blendColor = "#1374de"
          m.turnOn.blendColor = "#1374de"
          m.pToggleBox.opacity = 1
          m.rightText.color = "#FFFFFF"
          m.leftText.color = "#FFFFFF"
      else
          m.turnOff.blendColor = "#FFFFFF"
          m.turnOn.blendColor = "#FFFFFF"
          m.pToggleBox.opacity = 0.7
          if m.turnOn.visible
              m.rightText.color = "#000000"
              m.leftText.color = "#FFFFFF"
          else
              m.rightText.color = "#FFFFFF"
              m.leftText.color = "#000000"
          end if
      end if
end function

function OnToggleSwitchSet(event as dynamic)
    onOffswitch = event.getData()
    If (onOffswitch)
        m.turnOn.visible = true
        if m.top.hasFocus() or m.top.IsInFocusChain()
            m.rightText.color = "#FFFFFF"
        else
            m.rightText.color = "#000000"
        end if
        m.turnOff.visible = false
    Else
        m.turnOn.visible = false
        m.turnOff.visible = true
        if m.top.hasFocus() or m.top.IsInFocusChain()
            m.leftText.color = "#FFFFFF"
        else
            m.leftText.color = "#000000"
        end if
    End If
    SetToggleSwitch()
end function

function OnOffToggle()
    toggleOnBoudingRect = m.turnOn.boundingRect()
    toggleOffBoudingRect = m.turnOff.boundingRect()
    if (m.top.toggleSwitchOn and toggleOnBoudingRect.x = 810) or (not m.top.toggleSwitchOn and toggleOffBoudingRect.x = 0)
        m.top.toggleSwitchOn = not m.top.toggleSwitchOn
    end if
end function

sub SetToggleSwitch()
    toggleOnBoudingRect = m.turnOn.boundingRect()
    toggleOffBoudingRect = m.turnOff.boundingRect()
    if m.top.toggleSwitchOn and toggleOnBoudingRect.x = 0
        m.toggleOffAnimation.control = "finish"
        m.toggleOnAnimation.control = "finish"
        m.toggleOnAnimation.control = "start"
        print "toggleOn"
    else if not m.top.toggleSwitchOn and toggleOffBoudingRect.x > 0
        m.toggleOffAnimation.control = "finish"
        m.toggleOnAnimation.control = "finish"
        m.toggleOffAnimation.control = "start"
        print "toggleOff"
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    print "onKeyEvent ToggleSwitch "press " "key
    if press and (key="OK" or (key="right" and m.turnOff.visible) or (key="left" and m.turnOn.visible))
      OnOffToggle()
      handled = true
    end if
    return handled
end function
