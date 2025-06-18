sub init()
    print "init CampaignView"
    m.scene = m.top.getScene()
    m.namiPaywallManager = invalid
    m.namiCustomerManager = invalid
    m.namiCampaignManager = invalid
    m.campaignList = invalid

    m.llCampaign = m.top.findNode("llCampaign")
    m.lNoItems = m.top.findNode("lNoItems")
    m.lVersion = m.top.findNode("lVersion")
    m.pvButton = m.top.findNode("pvButton")
    m.pv1Button = m.top.findNode("pv1Button")
    m.asyncVideo = m.top.findNode("asyncVideo")
    m.asyncVideo1 = m.top.findNode("asyncVideo1")
    m.asyncVideoGroup = m.top.findNode("asyncVideoGroup")

    m.llCampaign.observeField("itemSelected", "OnItemSelected")
    m.top.observeField("visible", "onVisibleChange")
    m.top.observeField("focusedChild","OnFocusedChildChange")
    m.pvButton.observeField("focusedChild","onPVButtonFocus")
    m.pv1Button.observeField("focusedChild","onPV1ButtonFocus")
end sub

sub onInitializeChanged(event as dynamic)
    initialize = event.getData()
    print "CampaignView : onInitializeChanged : initialize : " initialize
    if initialize
        m.campaignList = m.top.namiDataSource.campaigns
        print "CampaignView : onInitializeChanged : Campaign List " ' m.campaignList
        m.namiPaywallManager = m.scene.namiManager.namiPaywallManager
        m.namiCustomerManager = m.scene.namiManager.namiCustomerManager
        m.namiCampaignManager = m.scene.namiManager.namiCampaignManager
    end if
    if m.scene.namiManager <> invalid and m.scene.namiManager.namiSDKVersion <> invalid
        m.lVersion.text = "NAMI SDK Version : " + m.scene.namiManager.namiSDKVersion
    end if
end sub

sub onVisibleChange(event as dynamic)
    isVisible = event.getData()
    if m.namiPaywallManager <> invalid
        if isVisible
            ' Register the current view to load the paywallScreen on top of it.
            m.namiPaywallManager.callFunc("registerPaywallParentView", m.top)
            m.namiCampaignManager.callFunc("registerAvailableCampaignsHandler", m.top, "availableCampaignsHandlerCallback")
            m.llCampaign.setFocus(true)
        else
            m.namiPaywallManager.callFunc("deRegisterPaywallParentView", m.top)
        end if
    end if
end sub

sub OnFocusedChildChange()
    if m.top.hasFocus()
        m.llCampaign.setFocus(true)
    end if
end sub

sub onPVButtonFocus()
  if m.pvButton.hasFocus()
      m.pvButton.blendColor = "#1374de"
  else
      m.pvButton.blendColor = "#404040"
  end if
end sub

sub onPV1ButtonFocus()
  if m.pv1Button.hasFocus()
      m.pv1Button.blendColor = "#1374de"
  else
      m.pv1Button.blendColor = "#404040"
  end if
end sub

sub OnCampaignListReceived()
    m.scene.isCampaignRecieved = true
    if m.campaignList = invalid or m.campaignList.count() = 0
        m.llCampaign.content = invalid
        m.llCampaign.visible = false
        m.lNoItems.visible = true
        m.asyncVideoGroup.visible = false
        m.scene.callFunc("hideLoader")
        return
    end if

    m.lNoItems.visible = false

    ' deviceInfo = CreateObject("roDeviceInfo")
    ' id = deviceInfo.GetRandomUUID()
    ' m.namiCustomerManager.callFunc("login", id)

    m.llCampaign.content = parseCampaignList(m.campaignList)
    m.llCampaign.jumpToItem = 1
    m.llCampaign.visible = true
    m.asyncVideoGroup.visible = true
    m.scene.callFunc("hideLoader")
end sub

function parseCampaignList(campaignList as dynamic)
    parentNode = createObject("RoSGNode", "ContentNode")
    ' node = parentNode.createChild("ContentNode")
    ' node.title = "default"
    rowIndex = 1
    for each campaign in campaignList
        ' rowNode = parentNode.createChild("ContentNode")
        ' rowNode.title = campaign.name
        if campaign.typeField <> "default"
            node = parentNode.createChild("ContentNode")
            node.id = campaign.valueField + "label"
            node.title = campaign.valueField
            node.AddFields({"itemType":"label","colIndex":0, "rowIndex": rowIndex})
            node.addField("FHDItemWidth", "float", false)

            node = parentNode.createChild("ContentNode")
            node.id = campaign.valueField + "launch"
            node.title = campaign.valueField
            node.AddFields({"itemType":"launch","colIndex":1, "rowIndex": rowIndex})
            node.addField("FHDItemWidth", "float", false)

            node = parentNode.createChild("ContentNode")
            node.id = campaign.valueField + "context"
            node.title = campaign.valueField
            node.AddFields({"itemType":"context","colIndex":2, "rowIndex": rowIndex})
            node.addField("FHDItemWidth", "float", false)
            rowIndex++
        end if
    end for
    return parentNode
end function

sub onItemSelected(event as dynamic)
    selectedIndex = event.getData()
    paywallLaunchContext = CreateObject("roSGNode", "NamiSDK:PaywallLaunchContext")

    selectedNode = m.llCampaign.content.getChild(selectedIndex)
    label = selectedNode.title
    if selectedNode.colIndex = 1
        print "CampaignView : onItemSelected : Launching Campaign Label : " label
        m.namiPaywallManager.callFunc("registerCloseHandler", m.top, "paywallCloseHandler")
        m.namiCampaignManager.callFunc("launchWithHandler", label, paywallLaunchContext, m.top, "campaignLaunchHandler", m.top.namiDataSource, "paywallActionHandler")
    else if selectedNode.colIndex = 2
        if m.paywallLaunchContextPage = invalid
            m.paywallLaunchContextPage = createObject("roSGNode","PaywallLaunchContext")
            m.paywallLaunchContextPage.paywallLabel = label
            m.paywallLaunchContextPage.observeField("launchContextSet", "onPaywallLaunchContext")
            m.top.appendchild(m.paywallLaunchContextPage)
            m.paywallLaunchContextPage.setFocus(true)
        end if
    end if
end sub

sub onPaywallLaunchContext(event as dynamic)
    paywallLaunchContext = event.getData()
    label = ""
    if m.paywallLaunchContextPage <> invalid
        label = m.paywallLaunchContextPage.paywallLabel
        m.top.removeChild(m.paywallLaunchContextPage)
        m.paywallLaunchContextPage = invalid
    end if
    m.namiPaywallManager.callFunc("registerCloseHandler", m.top, "paywallCloseHandler")
    m.namiCampaignManager.callFunc("launchWithHandler", label, paywallLaunchContext, m.top, "campaignLaunchHandler", m.top.namiDataSource, "paywallActionHandler")
end sub

function campaignLaunchHandler(isSuccess as boolean, error as dynamic)
    print "CampaignView : campaignLaunchHandler : Is campaign launched successfully : "; isSuccess
    if isSuccess
        m.namiCampaignManager.callFunc("setPaywallFocus")
    else
        print "***** ERROR WHILE LAUNCHING CAMPAIGN *****"
        print "DOMAIN: " error.domain
        print "CODE: " error.code
        print "MESSAGE: " error.message
        print "***** ***** ***** ***** ***** ***** *****"
        showMessageDialog(error)
    end if
end function

sub paywallCloseHandler(isSuccess=true as boolean)
    print "CampaignView : paywallCloseHandler : Is paywall closed successfully : "; isSuccess
    if (isSuccess)
        m.llCampaign.setFocus(true)
    end if
end sub

sub showMessageDialog(error)
    m.dialog = createObject("roSgNode", "StandardMessageDialog")
    m.dialog.title = "ERROR - " + error.domain
    message = error.message
    m.dialog.message = [message]
    m.dialog.buttons = ["Ok"]

    ' observe the dialog's buttonSelected field to handle button selections
    m.dialog.observeFieldScoped("buttonSelected", "onButtonSelected")

    m.scene.dialog = m.dialog
end sub

sub closeDialog()
    if (m.scene.dialog <> invalid)
        m.scene.dialog.close = true
        m.scene.dialog = invalid
    end if
end sub

sub onButtonSelected()
    if m.dialog.buttonSelected = 0
        closeDialog()
    end if
end sub

sub availableCampaignsHandlerCallback(campaignsList as dynamic)
    if campaignsList <> invalid
        m.campaignList = campaignsList
        OnCampaignListReceived()
    end if
end sub

sub refreshData()
    m.llCampaign.visible = false
    m.Scene.callFunc("showLoader")
    m.namiCampaignManager.callFunc("refresh")
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if (press)
        print "CampaignView : onKeyEvent : key = " key " press = " press
        if (key = "back")
            if m.paywallLaunchContextPage <> invalid
                m.top.removeChild(m.paywallLaunchContextPage)
                m.paywallLaunchContextPage = invalid
                m.llCampaign.setFocus(true)
                result = true
            end if
        else if (key = "options")
            refreshData()
            result = true
        else if (key = "right")
            if m.llCampaign.hasFocus()
                m.pvButton.setFocus(true)
            end if
            result = true
        else if (key = "left")
            if m.pvButton.hasFocus() or m.pv1Button.hasFocus()
                m.llCampaign.setFocus(true)
            end if
            result = true
        else if (key = "up")
            if m.pv1Button.hasFocus()
                m.pvButton.setFocus(true)
                result = true
            end if
        else if (key = "down")
            if m.pvButton.hasFocus()
                m.pv1Button.setFocus(true)
                result = true
            end if
        else if (key = "OK")
          if m.namiPaywallManager <> invalid
              if m.pvButton.hasFocus()
                  if m.asyncVideo.visible
                      m.namiPaywallManager.callFunc("setAppSuppliedVideoDetails", invalid)
                      m.asyncVideo.visible = false
                  else
                      m.namiPaywallManager.callFunc("setAppSuppliedVideoDetails", {url: "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", name: "app-supplied-video-1"})
                      m.asyncVideo.visible = true
                  end if
                  m.asyncVideo1.visible = false
                  result = true
              else if m.pv1Button.hasFocus()
                  if m.asyncVideo1.visible
                      m.namiPaywallManager.callFunc("setAppSuppliedVideoDetails", invalid)
                      m.asyncVideo1.visible = false
                  else
                      m.namiPaywallManager.callFunc("setAppSuppliedVideoDetails", {url: "https://cdn.namiml.com/brand/video/nami-ad-move-fast.mov", name: "app-supplied-video-2"})
                      m.asyncVideo1.visible = true
                  end if
                  m.asyncVideo.visible = false
                  result = true
              end if
          end if
        end if
    end if
    return result
end function
