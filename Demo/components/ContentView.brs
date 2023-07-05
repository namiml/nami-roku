sub init()
    m.scene = m.top.getScene()
    m.campaignViewControl = m.top.findNode("campaignViewControl")
    m.profileViewControl = m.top.findNode("profileViewControl")

    m.top.observeField("visible", "onVisibleChange")

    m.isFirstTime = true
end sub

sub onInitializeChanged(event as dynamic)
    initialize = event.getData()
    print "ContentView : onInitializeChanged : initialize : " initialize
    if initialize
        m.namiDataSource = m.top.CreateChild("NamiDataSource")
        m.campaignViewControl.namiDataSource = m.namiDataSource
        ' m.profileViewControl.namiDataSource = m.namiDataSource
        m.campaignViewControl.initialize = true
        showCampaignView()
    end if
end sub

sub onVisibleChange(event as dynamic)
    isVisible = event.getData()
    if isVisible
        showCampaignView()
    end if
end sub

sub showCampaignView()
    m.campaignViewControl.visible = true
end sub

sub showProfileView()
    m.profileViewControl.namiDataSource = m.namiDataSource
    m.profileViewControl.visible = true
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if (press)
        print "ContentView : onKeyEvent : key = " key " press = " press
    end if
    return result
end function
