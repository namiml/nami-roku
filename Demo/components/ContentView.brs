sub init()
    print "init ContentView"
    m.scene = m.top.getScene()
    m.gTopMenu = m.top.findNode("gTopMenu")
    m.pShade = m.top.findNode("pShade")
    m.selectedPageTitle = m.top.findNode("selectedPageTitle")
    m.campaignViewControl = m.top.findNode("campaignViewControl")
    m.profileViewControl = m.top.findNode("profileViewControl")
    m.entitlementViewControl = m.top.findNode("entitlementViewControl")
    m.selectedPageTitle.font = "font:MediumBoldSystemFont"
    m.navbarEntries = {
      "menuList": [
          {
              "_id": 1,
              "title": "Campaigns",
              "icon": "pkg:/images/goal.png",
              "playlist_layout": "campaigns"
          },
          {
              "_id": 2,
              "title": "Profile",
              "icon": "pkg:/images/user-50.png",
              "playlist_layout": "profile"
          },
          {
              "_id": 3,
              "title": "Entitlements",
              "icon": "pkg:/images/favorite-50.png",
              "playlist_layout": "entitlements",
          }
      ]
  }
end sub

sub onInitializeChanged(event as dynamic)
    initialize = event.getData()
    print "ContentView : onInitializeChanged : initialize : " initialize
    if initialize
        m.namiDataSource = m.top.CreateChild("NamiDataSource")
        createTopMenu()
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
    m.selectedPageTitle.text = "Campaigns"
end sub

sub showProfileView()
    m.campaignViewControl.visible = false
    m.entitlementViewControl.visible = false
    if (not m.profileViewControl.initialize)
        m.profileViewControl.namiDataSource = m.namiDataSource
        m.profileViewControl.initialize = true
    end if
    m.profileViewControl.visible = true
    m.selectedPageTitle.text = "Profile"
end sub

sub showEntitlementView()
    m.campaignViewControl.visible = false
    m.profileViewControl.visible = false
    if (not m.entitlementViewControl.initialize)
        m.entitlementViewControl.namiDataSource = m.namiDataSource
        m.entitlementViewControl.initialize = true
    end if
    m.entitlementViewControl.visible = true
    m.selectedPageTitle.text = "Entitlements"
end sub

sub createTopMenu()
    if (m.topMenu <> invalid)
        m.gTopMenu.removeChild(m.topMenu)
    end if
    m.topMenu = m.gTopMenu.createChild("CustomMenuList")
    m.topMenu.id = "Menu"
    m.topMenu.MenuFocusedHeight = 5
    m.topMenu.MenuFocusedWidth = 100
    m.topMenu.observeField("rowitemFocused", "onTopMenuItemFocused")
    m.topMenu.observeField("customRowItemSelected", "OnNavbarItemSelected")
    m.topMenu.observeField("keyPress", "OnMenuKeyPress")
    m.topMenu.SetFirstItemSelected = false
    m.topMenu.selectedMenu = "home"
    m.topMenu.MenuItems = m.navbarEntries.menuList
    m.pShade.translation = [(1920 - m.pShade.width)/2, 50]
    m.topMenu.translation = [0, 0]
    m.focusMenuId = m.topMenu.id
end sub

function getSelectedMenu()
    if m.topMenu <> invalid
        index = [0, 0]
        if m.topMenu.customRowItemSelected <> invalid
            index = m.topMenu.customRowItemSelected
        end if
        selectedItem = m.topMenu.content.getChild(index[0]).getChild(index[1])
        return selectedItem
    end if
    return invalid
end function

sub setInitialFocus()
    m.topMenu.setFocus(true)
    m.topMenu.itemSelected = 0
end sub

sub OnNavbarItemSelected(event as dynamic)
    itemSelected =  getSelectedMenu()
    if (itemSelected.title = "Campaigns")
        showCampaignView()
    else if (itemSelected.title = "Profile")
        showProfileView()
    else if (itemSelected.title = "Entitlements")
        showEntitlementView()
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if (press)
        print "ContentView : onKeyEvent : key = " key " press = " press
        if key = "up"
            m.topMenu.setFocus(true)
            result = true
        else if key = "down"
            if (m.topMenu.hasFocus())
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
