sub init()
    setControls()
    setupColor()
    setupFont()
end sub

sub setControls()
    m.pButton = m.top.findNode("pButton")
    m.buttonText = m.top.findNode("buttonText")
    m.itemTitle = m.top.findNode("itemTitle")
    m.background = m.top.findNode("background")
    ' m.border = m.top.findNode("background")
end sub

sub setupColor()
    m.buttonText.color = "#FFFFFF"
    m.pButton.blendColor = "#404040"
    m.itemTitle.color = "#000000"
end sub

sub setupFont()
  m.itemTitle.font = "font:SmallestSystemFont"
end sub

sub itemContentChanged()
    m.itemcontent = m.top.itemContent
    m.background.width = m.top.width
    m.background.height = m.top.height
    m.itemTitle.height = m.top.height
    ' m.border.width = m.top.width
    ' m.border.height = m.top.height
    if (m.itemcontent.rowIndex mod 2 = 0)
      m.background.blendColor = "#C0C0C0"
    else
      m.background.blendColor = "#A0A0A0"
    end if
    if (m.itemcontent <> invalid)
        if m.itemcontent.itemType = "label"
            m.itemTitle.text = m.itemcontent.title
            m.itemTitle.width = 520
            m.itemTitle.visible = true
            m.pButton.visible = false
            m.background.uri = "pkg:/images/left_radius16.9.png"
        else if m.itemcontent.itemType = "launch"
            m.buttonText.text = "launch"
            m.pButton.visible = true
            m.itemTitle.visible = false
            m.pButton.width = 150
            m.buttonText.width = 150
            m.background.uri = "pkg:/images/rectangle.9.png"
            m.pButton.translation = [(m.top.width - m.pButton.width)/2, (m.top.height - m.pButton.height)/2]
        else if m.itemcontent.itemType = "context"
            m.buttonText.text = "launch with context"
            m.pButton.visible = true
            m.itemTitle.visible = false
            m.pButton.width = 350
            m.buttonText.width = 350
            m.background.uri = "pkg:/images/right_radius16.9.png"
            m.pButton.translation = [(m.top.width - m.pButton.width)/2, (m.top.height - m.pButton.height)/2]
        end if
    end if
end sub

sub setSize(percent as float)
  m.itemcontent = m.top.itemContent
  if (m.itemcontent <> invalid)
      if percent > 0.5
          if m.itemcontent.itemType = "label"
              m.itemTitle.color = "#1374de"
          else if m.itemcontent.itemType = "launch"
              m.pButton.blendColor = "#1374de"
          else if m.itemcontent.itemType = "context"
              m.pButton.blendColor = "#1374de"
          end if
      else
        if m.itemcontent.itemType = "label"
            m.itemTitle.color = "#000000"
        else if m.itemcontent.itemType = "launch"
            m.pButton.blendColor = "#404040"
        else if m.itemcontent.itemType = "context"
            m.pButton.blendColor = "#404040"
        end if
      end if
  end if
end sub

sub focusPercentChanged(event as dynamic)
    value = event.GetData()
    if ((m.top.rowListHasFocus and m.top.RowHasFocus) or m.top.gridHasFocus)
        setSize(value)
    else
        setSize(0)
    end if
end sub

sub itemHasFocusChanged(event as dynamic)
    value = event.GetData()
    if (value)
        SetSize(1)
    end if
end sub

sub rowHasFocusChanged()
    if (m.top.RowHasFocus and m.top.ItemHasFocus)
        SetSize(1)
    else
        SetSize(0)
    end if
end sub

sub parentHasFocusChanged()
    if (((m.top.RowListHasFocus and m.top.RowHasFocus) or m.top.GridHasFocus) and (m.top.ItemHasFocus or m.top.FocusPercent = 1))
        SetSize(1)
    else
        SetSize(0)
    end if
end sub
