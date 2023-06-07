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
    end if
end sub

sub OnDataSourceReceived()
    m.top.getScene().observeField("paywallScreenDismissed", "OnPaywallScreenDismissed")
    m.top.namiDataSourceNode.observeField("paywallScreenDismissed", "OnPaywallScreenDismissed")
end sub

sub OnPaywallScreenDismissed(event as dynamic)
    print "OnPaywallScreenDismissed - " OnPaywallScreenDismissed
    isDismissed = event.getData()
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
    m.scene.callFunc("hideLoader")
end sub

sub onItemSelected(event as dynamic)
    selectedIndex = event.getData()
    m.scene = m.top.getScene()
    m.namiSDK = m.scene.findNode("namiSDK")
    m.namiCampaignManager = m.namiSDK.findNode("NamiCampaignManagerObj")
    if selectedIndex = 0
        print "CampaignView : onItemSelected : default campaign is selected"
        m.namiCampaignManager.unobserveField("campaignLaunchHandler")
        m.namiCampaignManager.observeField("campaignLaunchHandler", "OnCampaignLaunchHandler")
        m.namiCampaignManager.callFunc("launch")
    else
        print "CampaignView : onItemSelected : selected campaign is - " m.top.campaignList[selectedIndex - 1].valueField
        m.namiCampaignManager.unobserveField("campaignLaunchHandler")
        m.namiCampaignManager.observeField("campaignLaunchHandler", "OnCampaignLaunchHandler")
        m.namiCampaignManager.callFunc("launchWithLabel", m.top.campaignList[selectedIndex - 1].valueField)
    end if
    m.scene.paywallScreenDismissed = false
end sub

function OnCampaignLaunchHandler()
    ' TODO : implement the flow for this
end function
