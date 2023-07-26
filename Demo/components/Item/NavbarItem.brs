sub init()
    m.top.id = "NavbarItem"
    m.itemText = m.top.findNode("itemText")
    m.itemSelect = m.top.findNode("itemSelect")
    m.itemFocus = m.top.findNode("itemFocus")
end sub

sub showContent()
    itemContent = m.top.itemContent
    m.itemText.text = itemContent.title
    if itemContent.isSelected
        m.itemSelect.visible = true
        m.itemText.color = "#FFFFFF"
    else
        m.itemSelect.visible = false
        m.itemText.color = "#000000"
    end if
end sub

sub focusPercentChanged(event as Dynamic)
    value = event.GetData()
    if (m.top.gridHasFocus)
        changeFocus(value)
    else
        changeFocus(0)
    end if
end sub

sub itemHasFocusChanged(event as Dynamic)
    value = event.GetData()
    if (value)
        changeFocus(1)
    end if
end sub

sub gridHasFocusChanged()
    if (m.top.GridHasFocus And (m.top.ItemHasFocus Or m.top.FocusPercent = 1))
        changeFocus(1)
    else
        changeFocus(0)
    end if
end sub

sub changeFocus(focusPercent)
    m.itemFocus.opacity = focusPercent
end sub
