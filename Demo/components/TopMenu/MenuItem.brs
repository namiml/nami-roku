
sub init()
    setLocals()
    setControls()
    setupFonts()
    setupColor()
end sub


sub setControls()
    m.pFocusedBorder = m.top.findNode("pFocusedBorder")
    m.title = m.top.findNode("title")
    m.focusTitle = m.top.findNode("focusTitle")
    m.selectedTitle = m.top.findNode("selectedTitle")
    m.icon = m.top.findNode("icon")
    m.focusIcon = m.top.findNode("focusIcon")
    m.selectedIcon = m.top.findNode("selectedIcon")
    m.lastPercent = -1
    m.itemContent = invalid
end sub

sub setLocals()
    m.fonts = m.global.fonts
    m.theme = m.global.appTheme
    m.scene = m.top.GetScene()
end sub

sub setupFonts()
    ' m.title.font = m.fonts.MontserratBold19
    ' m.focusTitle.font = m.fonts.MontserratBold19
    ' m.selectedTitle.font = "font:MediumBoldSystemFont"
end sub

sub setupColor()
    m.title.color = "#000000"
    m.focusTitle.color = "#E5E4E2"
    m.selectedTitle.color = "#FFFFFF"
    m.pFocusedBorder.blendcolor = "#1374de"
    m.icon.blendColor = "#000000"
    m.focusIcon.blendColor = "#E5E4E2"
    m.selectedIcon.blendColor = "#FFFFFF"
end sub

sub itemContentChanged()
    m.itemContent = m.top.itemContent
    m.title.visible = false
    m.icon.uri = ""
    m.icon.visible = false
    updateFocusAndSelectedItem()
    ' m.pSelectedBorder.visible = m.itemContent.isSelected
    m.pFocusedBorder.width = m.title.BoundingRect().width
end sub

sub updateFocusAndSelectedItem()
    m.title.color = "#000000"
    m.icon.blendColor = "#000000"
    if m.itemContent.isFocus = true
        m.pFocusedBorder.opacity = 1
    else if m.itemContent.isFocus = false
        m.pFocusedBorder.opacity = 0
    end if

    if m.itemContent.title <> ""
        m.title.text = m.itemContent.title
        m.focusTitle.text = m.itemContent.title
        m.selectedTitle.text = m.itemContent.title
        if m.itemContent.isSelected and m.itemContent.isFocus = false
            m.title.color = "#FFFFFF"
        end if
        m.title.visible = true
    end if
    if m.itemContent.ICON <> ""
        m.icon.uri = m.itemContent.ICON
        m.focusIcon.uri = m.itemContent.ICON
        m.selectedIcon.uri = m.itemContent.ICON
        if m.itemContent.isSelected and m.itemContent.isFocus = false
            m.selectedIcon.opacity = 1
            m.icon.opacity = 0
            m.focusIcon.opacity = 0
            m.selectedTitle.opacity = 1
            m.title.opacity = 0
            m.focusTitle.opacity = 0
        else if m.itemContent.isFocus = true
            m.selectedIcon.opacity = 0
            m.icon.opacity = 0
            m.focusIcon.opacity = 1
            m.selectedTitle.opacity = 0
            m.title.opacity = 0
            m.focusTitle.opacity = 1
        else
            m.selectedIcon.opacity = 0
            m.icon.opacity = 1
            m.focusIcon.opacity = 0
            m.selectedTitle.opacity = 0
            m.title.opacity = 1
            m.focusTitle.opacity = 0
        end if
        m.icon.visible = true
        if (m.title.visible = false)
            m.icon.translation = [25, 20]
            m.focusIcon.translation = [25, 20]
            m.selectedIcon.translation = [25, 20]
        else
            m.icon.translation = [10, 20]
            m.focusIcon.translation = [10, 20]
            m.selectedIcon.translation = [10, 20]
        end if
    end if
end sub

sub onWidthChanged()
    m.title.width = m.top.width
end sub

sub setSize(percent as float)
    m.pFocusedBorder.opacity = percent
    ' if (m.lastPercent <> -1 and percent > m.lastPercent)
    '     m.title.color = m.theme.White
    '     m.icon.blendColor = m.theme.White
    ' else if (m.lastPercent <> -1 and percent < m.lastPercent)
    '     if m.itemContent <> invalid and m.itemContent.isSelected and not m.itemContent.isFocus
    '         m.title.color = m.theme.themeColor
    '         m.icon.blendColor = m.theme.themeColor
    '     else if m.itemContent.isLive = false
    '         m.title.color = m.theme.White
    '         m.icon.blendColor = m.theme.White
    '     end if
    '     if not(m.itemContent.isLive and m.itemContent.title = "LIVE" and m.scene.isLive)
    '         m.pLiveBorder.opacity = percent
    '     end if
    ' end if
    ' m.lastPercent = percent'
    if m.itemContent <> invalid and m.itemContent.isSelected and not m.itemContent.isFocus
        m.selectedIcon.opacity = 1 - percent
        m.selectedTitle.opacity = 1 - percent
    end if
    m.focusIcon.opacity = percent
    m.focusTitle.opacity = percent
    m.icon.opacity = 1 - percent
    m.title.opacity = 1 - percent
    updateFocusAndSelectedItem()
end sub

sub focusPercentChanged(event as dynamic)
    value = event.GetData()
    if (m.top.rowListHasFocus and m.top.RowHasFocus)
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
    if ((m.top.RowListHasFocus and m.top.RowHasFocus) and (m.top.ItemHasFocus or m.top.FocusPercent = 1))
        SetSize(1)
    else
        SetSize(0)
    end if
end sub
