sub init()
    setControls()
    setupColor()
    setObservers()
    initialize()
end sub

sub setControls()
  m.scene = m.top.getScene()
  m.uiResolution = CreateObject("roDeviceInfo").GetUIResolution()
  m.mainLG = m.top.findNode("mainLG")
  m.namiHostLG = m.top.findNode("namiHostLG")
  m.gNamiHost = m.top.findNode("gNamiHost")
  m.namiHostFocusImage = m.top.findNode("namiHostFocusImage")
  m.currentNamiHost = m.top.findNode("currentNamiHost")
  m.namiHostGroup = m.top.findNode("namiHostGroup")
  m.hiddenNamiHostLabel = m.top.findNode("hiddenNamiHostLabel")

  m.appPlatformLG = m.top.findNode("appPlatformLG")

  m.logLevelLG = m.top.findNode("logLevelLG")
  m.gLogLevel = m.top.findNode("gLogLevel")
  m.logLevelFocusImage = m.top.findNode("logLevelFocusImage")
  m.currentLogLevel = m.top.findNode("currentLogLevel")
  m.logLevelGroup = m.top.findNode("logLevelGroup")
  m.hiddenLogLevelLabel = m.top.findNode("hiddenLogLevelLabel")

  m.languageLG = m.top.findNode("languageLG")
  m.glanguage = m.top.findNode("glanguage")
  m.languageFocusImage = m.top.findNode("languageFocusImage")
  m.currentLanguage = m.top.findNode("currentLanguage")
  m.languageGroup = m.top.findNode("languageGroup")
  m.hiddenLanguageLabel = m.top.findNode("hiddenLanguageLabel")

  m.pButton = m.top.findNode("pButton")
  if(m.uiResolution.name = "HD")
      m.namiHostFocusImage.uri="pkg:/images/focus/R16Filled_62px_hd.9.png"
      m.namiHostGroup.uri="pkg:/images/focus/R16T2_56px_hd.9.png"
      m.logLevelFocusImage.uri="pkg:/images/focus/R16Filled_62px_hd.9.png"
      m.logLevelGroup.uri="pkg:/images/focus/R16T2_56px_hd.9.png"
      m.languageFocusImage.uri="pkg:/images/focus/R16Filled_62px_hd.9.png"
      m.languageGroup.uri="pkg:/images/focus/R16T2_56px_hd.9.png"
  else
      m.namiHostFocusImage.uri="pkg:/images/focus/R16Filled_62px_fhd.9.png"
      m.namiHostGroup.uri="pkg:/images/focus/R16T2_56px_fhd.9.png"
      m.logLevelFocusImage.uri="pkg:/images/focus/R16Filled_62px_fhd.9.png"
      m.logLevelGroup.uri="pkg:/images/focus/R16T2_56px_fhd.9.png"
      m.languageFocusImage.uri="pkg:/images/focus/R16Filled_62px_fhd.9.png"
      m.languageGroup.uri="pkg:/images/focus/R16T2_56px_fhd.9.png"
  end if
end sub

sub setupColor()
  m.currentNamiHost.color = "#FFFFFF"
  m.namiHostGroup.blendColor = "#484848"
  m.namiHostFocusImage.blendColor = "#484848"

  m.currentLogLevel.color = "#FFFFFF"
  m.logLevelGroup.blendColor = "#484848"
  m.logLevelFocusImage.blendColor = "#484848"

  m.currentLanguage.color = "#FFFFFF"
  m.languageGroup.blendColor = "#484848"
  m.languageFocusImage.blendColor = "#484848"
end sub

sub setObservers()
  m.top.observeField("focusedChild", "onFocusedChild")
  m.namiHostGroup.observeField("focusedChild", "OnNamiHostGroupFocusesChild")
  m.logLevelGroup.observeField("focusedChild", "OnLogLevelGroupFocusesChild")
  m.languageGroup.observeField("focusedChild", "OnLanguageGroupFocusesChild")
  m.pButton.observeField("focusedChild", "OnButtonFocusesChild")
end sub

sub initialize()
  namiHostInit()
  appPlatformInit()
  logLevelInit()
  languageInit()
end sub

sub namiHostInit()
    m.namiHost = ParseJson(ReadAsciiFile("pkg:/source/data/namiHost.json"))
    m.hiddenNamiHostLabel.text = m.namiHost[0].key
    namiHostGroupWidth = m.hiddenNamiHostLabel.BoundingRect().width + 60
    namiHostGroupHeight = m.hiddenNamiHostLabel.BoundingRect().height + 30
    m.currentNamiHost.width = namiHostGroupWidth
    m.namiHostGroup.width = namiHostGroupWidth
    m.namiHostFocusImage.width = namiHostGroupWidth
    m.currentNamiHost.height = namiHostGroupHeight
    m.namiHostGroup.height = namiHostGroupHeight
    m.namiHostFocusImage.height = namiHostGroupHeight
    m.currentNamiHost.text = m.hiddenNamiHostLabel.text
    m.currentNamiHostValue = m.namiHost[0].value
end sub

sub appPlatformInit()
    m.appPlatform = ParseJson(ReadAsciiFile("pkg:/source/data/appPlatform.json"))
    createAppPlatformInit()
end sub

sub logLevelInit()
    m.logLevel = ParseJson(ReadAsciiFile("pkg:/source/data/logLevel.json"))
    m.hiddenLogLevelLabel.text = m.logLevel[0].key
    logLevelGroupWidth = m.hiddenLogLevelLabel.BoundingRect().width + 60
    logLevelGroupHeight = m.hiddenLogLevelLabel.BoundingRect().height + 30
    m.currentLogLevel.width = logLevelGroupWidth
    m.logLevelGroup.width = logLevelGroupWidth
    m.logLevelFocusImage.width = logLevelGroupWidth
    m.currentLogLevel.height = logLevelGroupHeight
    m.logLevelGroup.height = logLevelGroupHeight
    m.logLevelFocusImage.height = logLevelGroupHeight
    m.currentLogLevel.text = m.hiddenLogLevelLabel.text
    m.currentLogLevelValue = m.logLevel[0].value
end sub

sub languageInit()
    m.language = ParseJson(ReadAsciiFile("pkg:/source/data/language.json"))
    m.hiddenLanguageLabel.text = m.language[0].key
    languageGroupWidth = m.hiddenLanguageLabel.BoundingRect().width + 60
    languageGroupHeight = m.hiddenLanguageLabel.BoundingRect().height + 30
    m.currentLanguage.width = languageGroupWidth
    m.languageGroup.width = languageGroupWidth
    m.languageFocusImage.width = languageGroupWidth
    m.currentLanguage.height = languageGroupHeight
    m.languageGroup.height = languageGroupHeight
    m.languageFocusImage.height = languageGroupHeight
    m.currentLanguage.text = m.hiddenLanguageLabel.text
    m.currentLanguageValue = m.language[0].value
end sub

sub createAppPlatformInit()
    checkRemoveAppPlatfromChilds()
    m.gAppPlatform = createObject("roSGNode", "Group")
    m.gAppPlatform.id = "gAppPlatform"
    currentNamiHostID = LCase(m.currentNamiHost.text.Replace(" ", ""))
    if currentNamiHostID = "localhost"
        m.localPlatformId = ""
        m.customPlatformIdGrp = m.gAppPlatform.createChild("LayoutGroup")
        m.customPlatformIdGrp.layoutDirection = "horiz"
        m.customPlatformIdGrp.itemSpacings = 10
        m.customPlatformIdGrp.vertAlignment = "center"
        m.localPlatformId = ""
        m.lCustomAppPlatform = m.customPlatformIdGrp.createChild("Label")
        m.lCustomAppPlatform.id = "lCustomAppPlatform"
        m.lCustomAppPlatform.text = "App Platform ID"
        m.lCustomAppPlatform.width = 300
        createPlatfromField(m.customPlatformIdGrp, 800, false)
    else if currentNamiHostID = "custom"
        m.customLG = m.gAppPlatform.createChild("LayoutGroup")
        m.customLG.layoutDirection = "vert"
        m.customLG.itemSpacings = 10

        m.customHostGrp = m.customLG.createChild("LayoutGroup")
        m.customHostGrp.layoutDirection = "horiz"
        m.customHostGrp.vertAlignment = "center"
        m.customHostGrp.itemSpacings = 10
        m.customHostName = ""
        m.lCustomHostName = m.customHostGrp.createChild("Label")
        m.lCustomHostName.id = "lCustomHostName"
        m.lCustomHostName.text = "Custom Hostname"
        m.lCustomHostName.width = 300
        createHostField(m.customHostGrp, 800, false)

        m.customPlatformIdGrp = m.customLG.createChild("LayoutGroup")
        m.customPlatformIdGrp.layoutDirection = "horiz"
        m.customPlatformIdGrp.itemSpacings = 10
        m.customPlatformIdGrp.vertAlignment = "center"
        m.localPlatformId = ""
        m.lCustomAppPlatform = m.customPlatformIdGrp.createChild("Label")
        m.lCustomAppPlatform.id = "lCustomAppPlatform"
        m.lCustomAppPlatform.text = "App Platform ID"
        m.lCustomAppPlatform.width = 300
        createPlatfromField(m.customPlatformIdGrp, 800, false)
    else
        m.lappPlatform = m.appPlatformLG.createChild("Label")
        m.lappPlatform.id = "lappPlatform"
        m.lappPlatform.text = "App Platform ID"
        m.lappPlatform.width = "300"

        m.namiPlatformFocusImage = m.gAppPlatform.createChild("Poster")
        m.namiPlatformFocusImage.id = "namiPlatformFocusImage"
        m.namiPlatformFocusImage.width = 70
        m.namiPlatformFocusImage.height = 70
        if(m.uiResolution.name = "HD")
            m.namiPlatformFocusImage.uri = "pkg:/images/focus/R16Filled_62px_hd.9.png"
        else
            m.namiPlatformFocusImage.uri = "pkg:/images/focus/R16Filled_62px_fhd.9.png"
        end if
        m.namiPlatformFocusImage.visible = false
        m.namiPlatformFocusImage.blendColor = "#484848"

        createCurrentPlatformNode(m.gAppPlatform)

        m.namiPlatformGroup = m.gAppPlatform.createChild("Poster")
        m.namiPlatformGroup.id = "namiPlatformGroup"
        m.namiPlatformGroup.width = 70
        m.namiPlatformGroup.height = 70
        if(m.uiResolution.name = "HD")
            m.namiPlatformGroup.uri = "pkg:/images/focus/R16T2_56px_hd.9.png"
        else
            m.namiPlatformGroup.uri = "pkg:/images/focus/R16T2_56px_fhd.9.png"
        end if
        m.namiPlatformGroup.blendColor = "#484848"
        m.namiPlatformGroup.observeField("focusedChild", "OnAppPlatformGroupFocusesChild")

        m.hiddenNamiPlatformLabel = m.gAppPlatform.createChild("MultiStyleLabel")
        m.hiddenNamiPlatformLabel.id = "hiddenNamiPlatformLabel"
        m.hiddenNamiPlatformLabel.text = ""
        m.hiddenNamiPlatformLabel.visible = false
    end if
    m.appPlatformLG.appendchild(m.gAppPlatform)
    if m.hiddenNamiPlatformLabel <> invalid
        m.hiddenNamiPlatformLabel.text = m.appPlatform[currentNamiHostID][0].key
        appPlatformGroupWidth = m.hiddenNamiPlatformLabel.BoundingRect().width + 60
        appPlatformGroupHeight = m.hiddenNamiPlatformLabel.BoundingRect().height + 30
        m.currentNamiPlatform.width = appPlatformGroupWidth
        m.namiPlatformGroup.width = appPlatformGroupWidth
        m.namiPlatformFocusImage.width = appPlatformGroupWidth
        m.currentNamiPlatform.height = appPlatformGroupHeight
        m.namiPlatformGroup.height = appPlatformGroupHeight
        m.namiPlatformFocusImage.height = appPlatformGroupHeight
        m.currentNamiPlatform.text = m.hiddenNamiPlatformLabel.text
        m.currentNamiPlatformValue = m.appPlatform[currentNamiHostID][0].value
    end if
end sub

sub checkRemoveAppPlatfromChilds()
    if m.gAppPlatform <> invalid
        m.gAppPlatform.removeChildrenIndex(m.gAppPlatform.getChildCount(), 0)
        m.appPlatformLG.removeChild(m.gAppPlatform)
        m.appPlatformLG.removeChild(m.lappPlatform)
        m.gAppPlatform = invalid
        m.namiPlatformFocusImage = invalid
        m.currentNamiPlatform = invalid
        m.namiPlatformGroup = invalid
        m.hiddenNamiPlatformLabel = invalid
        m.lappPlatform = invalid
        m.customHostField = invalid
    end if
end sub

sub createCurrentPlatformNode(parentNode, size = 70 as integer, isCenter = true as boolean)
    m.currentNamiPlatform = parentNode.createChild("MultiStyleLabel")
    m.currentNamiPlatform.id = "currentNamiPlatform"
    m.currentNamiPlatform.width = size
    m.currentNamiPlatform.height = 70
    m.currentNamiPlatform.vertAlign = "center"
    m.currentNamiPlatform.vertAlign = "center"
    if isCenter
        m.currentNamiPlatform.horizAlign = "center"
    else
        m.currentNamiPlatform.translation = [15, 0]
        m.currentNamiPlatform.horizAlign = "left"
    end if
end sub

sub createHostField(parentHostNode, size, isCenter = true as boolean)
      m.customHostField = parentHostNode.createChild("Poster")
      m.customHostField.id = "customHostField"
      m.customHostField.width = size
      m.customHostField.height = 70
      if(m.uiResolution.name = "HD")
          m.customHostField.uri = "pkg:/images/focus/R16T2_56px_hd.9.png"
      else
          m.customHostField.uri = "pkg:/images/focus/R16T2_56px_fhd.9.png"
      end if
      m.customHostField.blendColor = "#484848"
      m.customHostField.observeField("focusedChild", "OnHostNameFieldFocusesChild")

      m.lCustomHostName = parentHostNode.createChild("MultiStyleLabel")
      m.lCustomHostName.id = "currentNamiPlatform"
      m.lCustomHostName.width = size
      m.lCustomHostName.height = 70
      m.lCustomHostName.vertAlign = "center"
      if isCenter
          m.lCustomHostName.horizAlign = "center"
      else
          m.lCustomHostName.horizAlign = "left"
          m.lCustomHostName.translation = [15, 0]
      end if
end sub

sub createPlatfromField(parentPlatformNode, size , isCenter = true as boolean)
    m.namiPlatformGroup = parentPlatformNode.createChild("Poster")
    m.namiPlatformGroup.id = "namiPlatformGroup"
    m.namiPlatformGroup.width = size
    m.namiPlatformGroup.height = 70
    if(m.uiResolution.name = "HD")
        m.namiPlatformGroup.uri = "pkg:/images/focus/R16T2_56px_hd.9.png"
    else
        m.namiPlatformGroup.uri = "pkg:/images/focus/R16T2_56px_fhd.9.png"
    end if
    m.namiPlatformGroup.blendColor = "#484848"
    m.namiPlatformGroup.observeField("focusedChild", "OnAppPlatformGroupFocusesChild")

    createCurrentPlatformNode(parentPlatformNode, size, isCenter)
end sub

sub onFocusedChild()
    if m.top.hasFocus()
        m.namiHostGroup.setFocus(true)
    end if
end sub

sub OnButtonFocusesChild()
    if m.pButton.hasFocus()
        m.pButton.blendColor = "#1374de"
    else
        m.pButton.blendColor = "#404040"
    end if
end sub

sub OnNamiHostGroupFocusesChild()
    if(m.namiHostGroup.hasFocus())
        m.namiHostFocusImage.visible = true
        m.namiHostGroup.blendColor = "#1374de"
    else
        m.namiHostFocusImage.visible = false
        m.namiHostGroup.blendColor = "#484848"
    end if
end sub

sub OnAppPlatformGroupFocusesChild()
  if(m.namiPlatformGroup.hasFocus())
      m.namiPlatformGroup.blendColor = "#1374de"
      if m.namiPlatformFocusImage <> invalid
        m.namiPlatformFocusImage.visible = true
      end if
  else
      m.namiPlatformGroup.blendColor = "#484848"
      if m.namiPlatformFocusImage <> invalid
        m.namiPlatformFocusImage.visible = false
      end if
  end if
end sub

sub OnHostNameFieldFocusesChild()
    if(m.customHostField.hasFocus())
        m.customHostField.blendColor = "#1374de"
    else
        m.customHostField.blendColor = "#484848"
    end if
end sub

sub OnLogLevelGroupFocusesChild()
  if(m.logLevelGroup.hasFocus())
      m.logLevelFocusImage.visible = true
      m.logLevelGroup.blendColor = "#1374de"
  else
      m.logLevelFocusImage.visible = false
      m.logLevelGroup.blendColor = "#484848"
  end if
end sub

sub OnLanguageGroupFocusesChild()
  if(m.languageGroup.hasFocus())
      m.languageFocusImage.visible = true
      m.languageGroup.blendColor = "#1374de"
  else
      m.languageFocusImage.visible = false
      m.languageGroup.blendColor = "#484848"
  end if
end sub

sub createNamiHostContent(namiHost)
    filterContent = {}
    if(m.namiHostSelection = invalid)
        filterContent.AddReplace("feedData", namiHost)
        filterContent.AddReplace("itemSize", [m.namiHostGroup.width, m.namiHostGroup.height])
        if namiHost.count() > 0
            m.namiHostSelection = CreateObject("roSGNode", "DropdownControl")
            m.namiHostSelection.contentInfo = filterContent
            m.namiHostSelection.observeField("selectedNode","OnNamiHostItemSelected")
            m.namiHostSelection.translation = [m.gNamiHost.translation[0], m.namiHostLG.translation[1] + (m.gNamiHost.translation[1] * -1)]
            m.top.appendchild(m.namiHostSelection)
            m.namiHostSelection.setFocus(true)
        end if
    end if
end sub

Sub OnNamiHostItemSelected(event as Dynamic)
    data = event.GetData()
    closeNamiHostDialog()
    If(m.currentNamiHostValue <> data.id)
        m.currentNamiHostValue = data.id
        m.currentNamiHost.text = data.title
        createAppPlatformInit()
    End If
End Sub

sub closeNamiHostDialog()
    if(m.namiHostSelection <> invalid)
        m.namiHostSelection.visible = false
        m.top.RemoveChild(m.namiHostSelection)
        m.namiHostSelection = invalid
        m.namiHostGroup.setFocus(true)
    end if
end sub

sub showDialogKeyboard(title as string, preEnteredText as string) as object
    dialog = CreateObject("roSGNode", "KeyboardDialog")
    dialog.buttons = [tr("OK"), tr("Cancel")]
    if title = "AppId"
        event_to_trigger = "dialogKeyboardButtonSelectedForAppPlatformId"
        title = "Set App Platform ID"
        dialog.keyboard.textEditBox.secureMode = false
    else if title = "hostname"
        event_to_trigger = "dialogKeyboardButtonSelectedForHostName"
        title = "Custom Hostname"
        dialog.keyboard.textEditBox.secureMode = false
    end if
    dialog.title = title
    dialog.text = preEnteredText
    dialog.keyboard.textEditBox.cursorPosition = Len(preEnteredText)
    dialog.observeField("buttonSelected", event_to_trigger)
    m.scene.dialog = dialog
end sub

sub dialogKeyboardButtonSelectedForAppPlatformId(event as object)
    bIndex = event.GetData()
    if bIndex = 0
        m.top.appPlatformId = m.scene.dialog.text.trim()
        if(Len(m.top.appPlatformId) > 0)
            m.localPlatformId = m.top.appPlatformId
            m.currentNamiPlatform.text = m.top.appPlatformId
        else
            m.currentNamiPlatform.text = ""
        end if
    end if
    m.currentNamiPlatformValue = m.top.appPlatformId
    m.scene.dialog.close = true
end sub

sub dialogKeyboardButtonSelectedForHostName(event as object)
    bIndex = event.GetData()
    if bIndex = 0
        m.top.hostname = m.scene.dialog.text.trim()
        if(Len(m.top.hostname) > 0)
            m.customHostName = m.top.hostname
            m.lCustomHostName.text = m.top.hostname
        else
            m.lCustomHostName.text = ""
        end if
    end if
    m.currentNamiHostValue = m.top.hostname
    m.scene.dialog.close = true
end sub

sub createAppPlatformContent(appPlatform)
    currentNamiHostID = LCase(m.currentNamiHost.text.Replace(" ", ""))
    if currentNamiHostID = "localhost" or currentNamiHostID = "custom"
        showDialogKeyboard("AppId", m.localPlatformId)
    else
        if(m.appPlatformSelection = invalid)
            filterContent = {}
            appPlatform = appPlatform[currentNamiHostID]
            filterContent.AddReplace("feedData", appPlatform)
            filterContent.AddReplace("itemSize", [m.namiPlatformGroup.width, m.namiPlatformGroup.height])
            if appPlatform.count() > 0
                m.appPlatformSelection = CreateObject("roSGNode", "DropdownControl")
                m.appPlatformSelection.contentInfo = filterContent
                m.appPlatformSelection.observeField("selectedNode","OnAppPlatformItemSelected")
                m.appPlatformSelection.translation = [m.gAppPlatform.translation[0], m.appPlatformLG.translation[1] + (m.gAppPlatform.translation[1] * -1)]
                m.top.appendchild(m.appPlatformSelection)
                m.appPlatformSelection.setFocus(true)
            end if
        end if
    end if
end sub

Sub OnAppPlatformItemSelected(event as Dynamic)
    data = event.GetData()
    closeAppPlatformDialog()
    If(m.currentNamiPlatformValue <> data.id)
        m.currentNamiPlatformValue = data.id
        m.currentNamiPlatform.text = data.title
    End If
End Sub

sub closeAppPlatformDialog()
    if(m.appPlatformSelection <> invalid)
        m.appPlatformSelection.visible = false
        m.top.RemoveChild(m.appPlatformSelection)
        m.appPlatformSelection = invalid
        m.namiPlatformGroup.setFocus(true)
    end if
end sub

sub createLogLevelContent(logLevel)
    filterContent = {}
    if(m.appPlatformSelection = invalid)
        filterContent.AddReplace("feedData", logLevel)
        filterContent.AddReplace("itemSize", [m.logLevelGroup.width, m.logLevelGroup.height])
        if logLevel.count() > 0
            m.logLevelSelection = CreateObject("roSGNode", "DropdownControl")
            m.logLevelSelection.contentInfo = filterContent
            m.logLevelSelection.observeField("selectedNode","OnLogLevelItemSelected")
            m.logLevelSelection.translation = [m.gLogLevel.translation[0], m.logLevelLG.translation[1] + (m.gLogLevel.translation[1] * -1)]
            m.top.appendchild(m.logLevelSelection)
            m.logLevelSelection.setFocus(true)
        end if
    end if
end sub

Sub OnLogLevelItemSelected(event as Dynamic)
    data = event.GetData()
    closeLogLevelDialog()
    If(m.currentLogLevelValue <> data.id)
        m.currentLogLevelValue = data.id
        m.currentLogLevel.text = data.title
    End If
End Sub

sub closeLogLevelDialog()
    if(m.logLevelSelection <> invalid)
        m.logLevelSelection.visible = false
        m.top.RemoveChild(m.logLevelSelection)
        m.logLevelSelection = invalid
        m.logLevelGroup.setFocus(true)
    end if
end sub

sub createLanguageContent(language)
    filterContent = {}
    if(m.languageSelection = invalid)
        filterContent.AddReplace("feedData", language)
        filterContent.AddReplace("itemSize", [m.languageGroup.width, m.languageGroup.height])
        if language.count() > 0
            m.languageSelection = CreateObject("roSGNode", "DropdownControl")
            m.languageSelection.contentInfo = filterContent
            m.languageSelection.observeField("selectedNode","OnLanaguageItemSelected")
            m.languageSelection.translation = [m.gLanguage.translation[0], m.languageLG.translation[1] + (m.gLanguage.translation[1] * -1)]
            m.top.appendchild(m.languageSelection)
            m.languageSelection.setFocus(true)
        end if
    end if
end sub

Sub OnLanaguageItemSelected(event as Dynamic)
    data = event.GetData()
    closeLanguageDialog()
    If(m.currentLanguageValue <> data.id)
        m.currentLanguageValue = data.id
        m.currentLanguage.text = data.title
    End If
End Sub

sub closeLanguageDialog()
    if(m.languageSelection <> invalid)
        m.languageSelection.visible = false
        m.top.RemoveChild(m.languageSelection)
        m.languageSelection = invalid
        m.languageGroup.setFocus(true)
    end if
end sub

function handleOKEvent()
    if m.namiHostGroup.hasFocus() and m.namiHostSelection = invalid
        createNamiHostContent(m.namiHost)
        return true
    else if m.customHostField <> invalid and m.customHostField.hasFocus()
        showDialogKeyboard("hostname", m.customHostName)
        return true
    else if m.namiPlatformGroup.hasFocus() and m.appPlatformSelection = invalid
        createAppPlatformContent(m.appPlatform)
        return true
    else if m.logLevelGroup.hasFocus() and m.logLevelSelection = invalid
        createLogLevelContent(m.logLevel)
        return true
    else if m.languageGroup.hasFocus() and m.languageSelection = invalid
        createLanguageContent(m.language)
        return true
    else if m.pButton.hasFocus()
        config = {
          namiHost: m.currentNamiHostValue
          appPlatformId: m.currentNamiPlatformValue
          logLevel: [m.currentLogLevelValue]
          language: m.currentLanguageValue
        }
        m.scene.namiConfig = config
        return true
    else
        closeNamiHostDialog()
        closeLogLevelDialog()
        closeAppPlatformDialog()
        closeLanguageDialog()
        return true
    end if
    return false
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if (press)
        print "NamiConfigration : onKeyEvent : key = " key " press = " press
        if key = "OK"
            result = handleOKEvent()
        else if key = "down"
            if(m.namiHostGroup.hasFocus())
                if m.customHostField <> invalid
                    m.customHostField.setFocus(true)
                else
                    m.namiPlatformGroup.setFocus(true)
                end if
            else if (m.customHostField <> invalid and m.customHostField.hasFocus())
                m.namiPlatformGroup.setFocus(true)
            else if(m.namiPlatformGroup.hasFocus())
                m.logLevelGroup.setFocus(true)
            else if(m.logLevelGroup.hasFocus())
                m.languageGroup.setFocus(true)
            else if(m.languageGroup.hasFocus())
                m.pButton.setFocus(true)
            end if
            result = true
        else if key = "up"
            if(m.pButton.hasFocus())
                m.languageGroup.setFocus(true)
            else if(m.languageGroup.hasFocus())
                m.logLevelGroup.setFocus(true)
            else if(m.logLevelGroup.hasFocus())
                m.namiPlatformGroup.setFocus(true)
            else if(m.namiPlatformGroup.hasFocus())
                if m.customHostField <> invalid
                    m.customHostField.setFocus(true)
                else
                    m.namiHostGroup.setFocus(true)
                end if
            else if m.customHostField <> invalid and m.customHostField.hasFocus()
                m.namiHostGroup.setFocus(true)
            end if
            result = true
        else if key = "back"
            if(m.namiHostSelection <> invalid and (m.namiHostSelection.hasFocus() or m.namiHostSelection.isInFocusChain()))
                closeNamiHostDialog()
                result = true
            else if(m.appPlatformSelection <> invalid and (m.appPlatformSelection.hasFocus() or m.appPlatformSelection.isInFocusChain()))
                closeAppPlatformDialog()
                result = true
            else if(m.logLevelSelection <> invalid and (m.logLevelSelection.hasFocus() or m.logLevelSelection.isInFocusChain()))
                closeLogLevelDialog()
                result = true
            else if(m.languageSelection <> invalid and (m.languageSelection.hasFocus() or m.languageSelection.isInFocusChain()))
                closeLanguageDialog()
                result = true
            end if
        end if
    end if
    return result
end function
