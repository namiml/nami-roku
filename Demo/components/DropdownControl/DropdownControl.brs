Sub Init()
    SetLocals()
    SetControls()
    SetObservers()
    SetupColor()
End Sub

Sub SetLocals()
    m.uiResolution = CreateObject("roDeviceInfo").GetUIResolution()
End Sub

Sub SetControls()
    m.filtersGrid = m.top.findNode("filtersGrid")
    m.backgroundImage = m.top.findNode("backgroundImage")
    If (m.uiResolution.name = "HD")
        m.backgroundImage.uri="pkg:/images/focus/R16Filled_62px_hd.9.png"
        m.filtersGrid.focusBitmapUri="pkg:/images/focus/R16T4_70px_hd.9.png"
    Else
        m.backgroundImage.uri="pkg:/images/focus/R16Filled_62px_fhd.9.png"
        m.filtersGrid.focusBitmapUri="pkg:/images/focus/R16T4_70px_fhd.9.png"
    End If
End Sub

Sub SetObservers()
    m.top.observeField("focusedChild", "OnFocusedChild")
    m.filtersGrid.observeField("itemSelected", "OnFilterItemSelected")
End Sub

Sub SetupColor()
    m.backgroundImage.blendColor = "#313131"
End Sub

Sub ItemContentInfoChanged(event as Dynamic)
    contentInfo = event.GetData()
    If(contentInfo <> invalid And contentInfo.itemSize <> invalid And contentInfo.feedData <> invalid And contentInfo.feedData.Count() > 0)
        contentSize = [contentInfo.itemSize[0] + 5, contentInfo.itemSize[1] + 5]

        m.filtersGrid.itemSize = contentSize
        m.backgroundImage.width = contentSize[0] - 4
        m.backgroundImage.height = contentSize[1] * contentInfo.feedData.Count() - 4
        m.backgroundImage.translation = [0, 4]
        filterContent = CreateObject("roSGNode", "ContentNode")
        For Each item in contentInfo.feedData
            childNode = filterContent.CreateChild("ContentNode")
            childNode.id = item.value
            childNode.title = item.key
        End For
        m.filtersGrid.content = filterContent
    End If
End Sub

Sub OnFilterItemSelected(event as Dynamic)
    data = event.GetData()
    m.top.selectedNode = m.filtersGrid.content.GetChild(data)
End Sub

Sub OnFocusedChild()
    If(m.top.hasFocus())
        m.filtersGrid.setFocus(true)
    End If
End Sub
