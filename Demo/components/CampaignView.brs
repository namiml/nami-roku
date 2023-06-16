sub init()
    m.scene = m.top.getScene()
    m.llCampaign = m.top.findNode("llCampaign")
    m.lNoItems = m.top.findNode("lNoItems")

    m.llCampaign.observeField("itemSelected", "OnItemSelected")
    m.top.observeField("visible", "onVisibleChange")
end sub

sub onVisibleChange(event as dynamic)
    isVisible = event.getData()
    if isVisible
        m.top.campaignList = m.top.namiDataSourceNode.campaigns
        m.llCampaign.setFocus(true)
    else
        m.scene = m.top.getScene()
        m.namiSDK = m.scene.findNode("namiSDK")
        if m.namiSDK <> invalid
            m.namiPaywallManager = m.namiSDK.findNode("NamiPaywallManagerObj")
            if m.namiPaywallManager <> invalid
                m.namiPaywallManager.callFunc("deRegisterPaywallParentView", m.top)
            end if
        end if
    end if
end sub

sub OnDataSourceReceived()
    m.top.getScene().observeField("paywallScreenDismissed", "OnPaywallScreenDismissed")
    m.top.namiDataSourceNode.observeField("paywallScreenDismissed", "OnPaywallScreenDismissed")
end sub

sub OnPaywallScreenDismissed(event as dynamic)
    isDismissed = event.getData()
    print "CampaignView : OnPaywallScreenDismissed : " isDismissed
    if (isDismissed)
        m.llCampaign.setFocus(true)
    end if
end sub

sub OnCampaignListReceived(event as dynamic)
    campaignList = event.getData()

    if campaignList = invalid or campaignList.count() = 0
        m.llCampaign.content = invalid
        m.llCampaign.visible = false
        m.lNoItems.visible = true
        m.scene.callFunc("hideLoader")
        return
    end if

    m.lNoItems.visible = false

    parentNode = createObject("RoSGNode", "ContentNode")

    node = parentNode.createChild("ContentNode")
    node.title = "default"

    for each campaign in campaignList
        node = parentNode.createChild("ContentNode")
        node.title = campaign.valueField
    end for

    m.llCampaign.content = parentNode
    m.llCampaign.visible = true

    'Register the current view to load the paywallScreen on top of it.
    m.scene = m.top.getScene()
    m.namiSDK = m.scene.findNode("namiSDK")
    m.namiPaywallManager = m.namiSDK.findNode("NamiPaywallManagerObj")
    m.namiPaywallManager.callFunc("registerPaywallParentView", m.top)

    m.scene.callFunc("hideLoader")
end sub

sub onItemSelected(event as dynamic)
    selectedIndex = event.getData()
    m.scene = m.top.getScene()
    m.namiSDK = m.scene.findNode("namiSDK")
    m.namiCampaignManager = m.namiSDK.findNode("NamiCampaignManagerObj")

    paywallLaunchContext = CreateObject("roSGNode", "NamiSDK:PaywallLaunchContext")
    paywallLaunchContext.productGroups = ["group1", "group2"]
    paywallLaunchContext.customAttributes = {
        "matchupImage": "https://www.exmaple.com/matchupImage.png"
    }

    if selectedIndex = 0
        print "CampaignView : onItemSelected : default campaign is selected"
        ' m.namiCampaignManager.callFunc("launch", m.top, "campaignLaunchHandler")
        m.namiCampaignManager.callFunc("launchWithHandler", "", paywallLaunchContext, m.top, "campaignLaunchHandler", m.top.namiDataSourceNode, "paywallActionHandler")
    else
        print "CampaignView : onItemSelected : selected campaign is - " m.top.campaignList[selectedIndex - 1].valueField
        ' m.namiCampaignManager.callFunc("launchWithLabel", m.top.campaignList[selectedIndex - 1].valueField, m.top, "campaignLaunchHandler")
        m.namiCampaignManager.callFunc("launchWithHandler", m.top.campaignList[selectedIndex - 1].valueField, paywallLaunchContext, m.top, "campaignLaunchHandler", m.top.namiDataSourceNode, "paywallActionHandler")
    end if
    m.scene.paywallScreenDismissed = false
end sub

function campaignLaunchHandler(isSuccess as boolean, error as dynamic)
    if not isSuccess
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
