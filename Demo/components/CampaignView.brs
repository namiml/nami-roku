sub init()
    m.scene = m.top.getScene()
    m.namiPaywallManager = invalid
    m.namiCustomerManager = invalid
    m.namiCampaignManager = invalid
    m.campaignList = invalid

    m.llCampaign = m.top.findNode("llCampaign")
    m.lNoItems = m.top.findNode("lNoItems")

    m.llCampaign.observeField("itemSelected", "OnItemSelected")
    m.top.observeField("visible", "onVisibleChange")
    m.top.observeField("focusedChild","OnFocusedChildChange")
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
        m.top.namiDataSource.observeField("paywallScreenDismissed", "OnPaywallScreenDismissed")
        OnCampaignListReceived()
    end if
end sub

sub onVisibleChange(event as dynamic)
    isVisible = event.getData()
    if m.namiPaywallManager <> invalid
        if isVisible
            ' Register the current view to load the paywallScreen on top of it.
            m.namiPaywallManager.callFunc("registerPaywallParentView", m.top)
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

sub OnPaywallScreenDismissed(event as dynamic)
    isDismissed = event.getData()
    print "CampaignView : OnPaywallScreenDismissed : " isDismissed
    if (isDismissed)
        m.llCampaign.setFocus(true)
    end if
end sub

sub OnCampaignListReceived()
    if m.campaignList = invalid or m.campaignList.count() = 0
        m.llCampaign.content = invalid
        m.llCampaign.visible = false
        m.lNoItems.visible = true
        m.scene.callFunc("hideLoader")
        return
    end if

    m.lNoItems.visible = false

    ' deviceInfo = CreateObject("roDeviceInfo")
    ' id = deviceInfo.GetRandomUUID()
    ' m.namiCustomerManager.callFunc("login", id)

    m.llCampaign.content = parseCampaignList(m.campaignList)
    m.llCampaign.visible = true

    m.scene.callFunc("hideLoader")
end sub

function parseCampaignList(campaignList as dynamic)
    parentNode = createObject("RoSGNode", "ContentNode")
    node = parentNode.createChild("ContentNode")
    node.title = "default"
    for each campaign in campaignList
        node = parentNode.createChild("ContentNode")
        node.title = campaign.valueField
    end for
    return parentNode
end function

sub onItemSelected(event as dynamic)
    selectedIndex = event.getData()
    paywallLaunchContext = CreateObject("roSGNode", "NamiSDK:PaywallLaunchContext")
    paywallLaunchContext.productGroups = ["group1","group2"]
    paywallLaunchContext.customAttributes = {
        "contextImage": "https://www.exmaple.com/contextImage.png"
    }

    label = ""
    if selectedIndex <> 0
        label = m.campaignList[selectedIndex - 1].valueField
    end if

    print "CampaignView : onItemSelected : Launching Campaign Label : " label

    m.namiPaywallManager.callFunc("registerCloseHandler", m.top, "campaignCloseHandler")
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

sub campaignCloseHandler(isSuccess=true as boolean)
    print "CampaignView : campaignCloseHandler : Is campaign closed successfully : "; isSuccess
    if (isSuccess)
        m.llCampaign.setFocus(true)
    end if
    ' m.top.namiDataSource.paywallScreenDismissed = isSuccess
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

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if (press)
        print "CampaignView : onKeyEvent : key = " key " press = " press
    end if
    return result
end function
