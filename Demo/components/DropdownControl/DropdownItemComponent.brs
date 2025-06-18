Sub Init()
    m.scene = m.top.GetScene()
    m.selectedMark = m.top.findNode("selectedMark")
    m.lTitle = m.top.findNode("lTitle")
    m.selectedMarkBack = m.top.findNode("selectedMarkBack")
    m.iconTextGrp = m.top.findNode("iconTextGrp")

    m.uiResolution = CreateObject("roDeviceInfo").GetUIResolution()
    If (m.uiResolution.name = "HD")
        m.selectedMark.uri="pkg:/images/focus/R16Filled_62px_hd.9.png"
        m.selectedMarkBack.uri="pkg:/images/focus/R16T2_56px_hd.9.png"
    Else
        m.selectedMark.uri="pkg:/images/focus/R16Filled_62px_fhd.9.png"
        m.selectedMarkBack.uri="pkg:/images/focus/R16T2_56px_fhd.9.png"
    End If

    m.top.lastFocusPercent = 0

    SetupFonts()
    SetupColor()
End Sub

Sub SetupFonts()
    ' m.lTitle.font = m.fonts.robotoMed28
End Sub

Sub SetupColor()
    m.lTitle.color = "#FFFFFF"
    m.selectedMark.blendColor = "#1374de"
    m.selectedMarkBack.blendColor = "#1374de"
End Sub

Sub OnContentChange()
    itemContent = m.top.itemContent
    m.lTitle.text  = itemContent.title
    SetButtonSize()
End Sub

Sub SetButtonSize()
    contentWidth = m.top.width - 5
    contentHeight = m.top.height - 5
    m.selectedMark.width = contentWidth
    m.selectedMark.height = contentHeight
    m.selectedMarkBack.width = contentWidth
    m.selectedMarkBack.height = contentHeight
    m.lTitle.color = "#FFFFFF"
    m.lTitle.width = contentWidth
    m.lTitle.height = contentHeight
End Sub

Sub ChangeFocus(focusPercent)
    If(m.top.itemContent <> invalid)
        m.selectedMarkBack.opacity = focusPercent
        m.selectedMark.opacity = focusPercent
    End If
    m.top.lastFocusPercent = focusPercent
End Sub

Sub FocusPercentChanged(event as Dynamic)
    value = event.GetData()
    If(m.top.gridHasFocus)
        ChangeFocus(value)
    End If
End Sub

Sub ItemHasFocusChanged(event as Dynamic)
    value = event.GetData()
    If(value)
        ChangeFocus(1)
    End If
End Sub

Sub ParentHasFocusChanged()
    If(m.top.gridHasFocus And (m.top.itemHasFocus Or m.top.focusPercent = 1))
        ChangeFocus(1)
    Else
        ChangeFocus(0)
    End If
End Sub
