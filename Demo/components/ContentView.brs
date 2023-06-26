sub init()
    m.scene = m.top.getScene()
    m.campaignViewControl = m.top.findNode("campaignViewControl")
    m.profileViewControl = m.top.findNode("profileViewControl")

    m.top.observeField("visible", "onVisibleChange")

    m.isFirstTime = true
end sub

sub setInitialValuesForNamiDataSource()
    m.namiDataSource = m.top.CreateChild("NamiDataSource")
end sub

sub onVisibleChange(event as dynamic)
    isVisible = event.getData()
    if isVisible
        ' TODO : RSS : When tabbar is implemented call this function based on current tab selection. 
        if m.isFirstTime = true
            m.isFirstTime = false
            setInitialValuesForNamiDataSource()
        end if
        showCampaignView()
        ' showProfileView()
    end if
end sub

sub showCampaignView()
    m.campaignViewControl.namiDataSourceNode = m.namiDataSource
    m.campaignViewControl.visible = true
end sub

sub showProfileView()
    m.profileViewControl.namiDataSourceNode = m.namiDataSource
    m.profileViewControl.visible = true
end sub