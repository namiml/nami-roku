sub init()
    m.scene = m.top.getScene()
    m.navbar = m.top.findNode("navbar")
    m.campaignViewControl = m.top.findNode("campaignViewControl")
    m.profileViewControl = m.top.findNode("profileViewControl")
    m.entitlementViewControl = m.top.findNode("entitlementViewControl")

    m.navbarEntries = ["Campaigns", "Profile", "Entitlements"]
    m.navbar.observeField("itemSelected","OnNavbarItemSelected")
end sub

sub onInitializeChanged(event as dynamic)
    initialize = event.getData()
    print "ContentView : onInitializeChanged : initialize : " initialize
    if initialize
        m.namiDataSource = m.top.CreateChild("NamiDataSource")
        setNavbarItems()
        setInitialFocus()
    end if
end sub

sub showCampaignView()
    m.profileViewControl.visible = false
    m.entitlementViewControl.visible = false
    if (not m.campaignViewControl.initialize)
        m.campaignViewControl.namiDataSource = m.namiDataSource
        m.campaignViewControl.initialize = true
    end if
    m.campaignViewControl.visible = true
end sub

sub showProfileView()
    m.campaignViewControl.visible = false
    m.entitlementViewControl.visible = false
    if (not m.profileViewControl.initialize)
        m.profileViewControl.namiDataSource = m.namiDataSource
        m.profileViewControl.initialize = true
    end if
    m.profileViewControl.visible = true
end sub

sub showEntitlementView()
    m.campaignViewControl.visible = false
    m.profileViewControl.visible = false
    if (not m.entitlementViewControl.initialize)
        m.entitlementViewControl.namiDataSource = m.namiDataSource
        m.entitlementViewControl.initialize = true
    end if
    m.entitlementViewControl.visible = true
end sub

sub setNavbarItems()
    navbarContent = createObject("roSGNode","ContentNode")
    for each item in m.navbarEntries
        navbarItem = navbarContent.createChild("NavbarContent")
        navbarItem.title = item
        navbarItem.isSelected = false
    end for
    m.navbar.content = navbarContent
    m.navbar.translation = [(1920 - m.navbar.boundingRect().width)/2, 70]
end sub

sub setInitialFocus()
    m.navbar.setFocus(true)
    m.navbar.itemSelected = 0
end sub

sub OnNavbarItemSelected(event as dynamic)
    index = event.getData()
    itemSelected =  m.navbar.content.getChild(index)
    updateSelectedItem(itemSelected.title)
    if (itemSelected.title = "Campaigns")
        showCampaignView()
    else if (itemSelected.title = "Profile")
        showProfileView()
    else if (itemSelected.title = "Entitlements")
        showEntitlementView()
    end if
end sub

sub updateSelectedItem(selectedtTitle as String)
    for index = 0 to m.navbar.content.getChildCount() - 1
        child = m.navbar.content.getChild(index)
        if child.title = selectedtTitle
            child.isSelected = true
        else
            child.isSelected = false
        end if
    end for
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if (press)
        print "ContentView : onKeyEvent : key = " key " press = " press
        if key = "up"
            m.navbar.setFocus(true)
            result = true
        else if key = "down"
            if (m.navbar.hasFocus())
                if (m.campaignViewControl.visible)
                    m.campaignViewControl.setFocus(true)
                else if (m.profileViewControl.visible)
                    m.profileViewControl.setFocus(true)
                end if
            end if
            result = true
        end if
    end if
    return result
end function
