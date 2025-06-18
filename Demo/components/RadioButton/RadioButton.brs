sub init()
    print "ToggleSwitch : Init"
    SetControls()
    SetupFonts()
    SetupColors()
    SetControls()
    SetObservers()
end sub

sub SetControls()
    m.turnOnOff = m.top.findNode("turnOnOff")
    m.radioText = m.top.findNode("radioText")
end sub

sub SetupFonts()
end sub

sub SetupColors()
end sub

sub SetObservers()
    m.top.observeField("focusedChild","OnFocusedChild")
end sub

function OnFocusedChild()
      if m.top.hasFocus()
          m.radioText.color = "#1374de"
      else
          m.radioText.color = "#FFFFFF"
      end if
end function

function OnOffToggle()
    m.top.radioOnOff = not m.top.radioOnOff
end function

sub OnRadioOnOff()
    if m.top.radioOnOff
        m.turnOnOff.uri = "pkg:/images/icons/On.png"
    else
        m.turnOnOff.uri = "pkg:/images/icons/Off.png"
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
