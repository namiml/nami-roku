sub init()
    m.scene = m.top.getScene()
    m.namiPaywallManager = invalid
    m.campaignList = invalid

    m.llCampaign = m.top.findNode("llCampaign")
    m.lNoItems = m.top.findNode("lNoItems")

    m.llCampaign.observeField("itemSelected", "OnItemSelected")
    m.top.observeField("visible", "onVisibleChange")
end sub

sub onInitializeChanged(event as dynamic)
    initialize = event.getData()
    print "CampaignView : onInitializeChanged : initialize : " initialize
    if initialize
        m.campaignList = m.top.namiDataSource.campaigns
        print "CampaignView : onInitializeChanged : Campaign List " m.campaignList
        m.namiPaywallManager = m.scene.namiSDK.nami.callFunc("getPaywallManager")
        m.scene.observeField("paywallScreenDismissed", "OnPaywallScreenDismissed")
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
    m.namiCampaignManager = m.scene.namiSDK.nami.callFunc("getCampaignManager")

    paywallLaunchContext = CreateObject("roSGNode", "NamiSDK:PaywallLaunchContext")
    paywallLaunchContext.productGroups = ["nfl_premium","nfl"]
    paywallLaunchContext.customAttributes = {
        "matchupImage": "https://www.exmaple.com/matchupImage.png"
    }

    if selectedIndex = 0
        print "CampaignView : onItemSelected : Launching default campaign"
        m.namiCampaignManager.callFunc("launchWithHandler", "", paywallLaunchContext, m.top, "campaignLaunchHandler", m.top.namiDataSource, "paywallActionHandler")
    else
        print "CampaignView : onItemSelected : Launching Campaign : " m.campaignList[selectedIndex - 1].valueField
        m.namiCampaignManager.callFunc("launchWithHandler", m.campaignList[selectedIndex - 1].valueField, paywallLaunchContext, m.top, "campaignLaunchHandler", m.top.namiDataSource, "paywallActionHandler")
    end if
    m.scene.paywallScreenDismissed = false
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
    if (m.scene.dialog <> invalid) then
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
