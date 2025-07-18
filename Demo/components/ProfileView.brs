sub init()
    print "init ProfileView"
    m.scene = m.top.getScene()
    m.isFirstTime = false
    m.isActionInProcess = false

    m.lDeviceId = m.top.findNode("lDeviceId")
    m.lUserInfo = m.top.findNode("lUserInfo")
    m.lJourneyState = m.top.findNode("lJourneyState")
    m.userAction = m.top.findNode("userAction")
    m.buttonText = m.top.findNode("buttonText")

    m.top.observeField("visible", "onVisibleChange")
    m.top.observeField("focusedChild", "OnFocusedChildChange")
    m.userAction.observeField("focusedChild", "OnUserActionFocusedChildChange")
end sub

sub onInitializeChanged(event as dynamic)
    initialize = event.getData()
    print "ProfileView : onIntializeChanged : initialize : " initialize
    if initialize
        m.namiPaywallManager = m.scene.namiManager.namiPaywallManager
        m.namiCustomerManager = m.scene.namiManager.namiCustomerManager
        updateProfileView()
    end if
end sub

sub onVisibleChange(event as dynamic)
    isVisible = event.getData()
    if isVisible
        m.userAction.setFocus(true)
        updateProfileView()
    else
    end if
end sub

sub OnFocusedChildChange()
    if m.top.hasFocus()
        m.userAction.setFocus(true)
    end if
end sub

sub OnUserActionFocusedChildChange()
    if m.userAction.hasFocus()
        m.userAction.blendColor = "#1374de"
    else
        m.userAction.blendColor = "#404040"
    end if
end sub

sub updateProfileView()
    m.isActionInProcess = false
    m.lDeviceId.text = "Device ID: " + m.namiCustomerManager.callFunc("deviceId")

    if m.top.namiDataSource.isLoggedIn = true
        m.buttonText.text = "Logout"
        m.lUserInfo.text = "Registered User: External ID: " + m.top.namiDataSource.loggedInId
        m.userAction.width = "210"
        m.buttonText.width = "210"
    else
        m.buttonText.text = "Login"
        m.lUserInfo.text = "Anonymous User"
        m.userAction.width = "180"
        m.buttonText.width = "180"
    end if
    userActionRect = m.userAction.boundingRect()
    centerx = (1920 - userActionRect.width) / 2
    m.userAction.translation = [centerx, 520]

    m.scene.callFunc("hideLoader")
end sub

sub OnUserAction()
    m.scene.callFunc("showLoader")

    m.top.namiDataSource.unobserveField("isUpdated")
    m.top.namiDataSource.observeField("isUpdated", "OnDataSourceUpdated")

    m.isActionInProcess = true
    if m.top.namiDataSource.isLoggedIn = true
        OnUserActionLogout()
    else
        OnUserActionLogin()
    end if
end sub

sub OnUserActionLogout()
    m.namiCustomerManager.callFunc("logout")
end sub

sub OnUserActionLogin()
    deviceInfo = CreateObject("roDeviceInfo")
    id = deviceInfo.GetRandomUUID()
    m.namiCustomerManager.callFunc("login", id)
end sub

sub OnDataSourceUpdated()
    updateProfileView()
end sub

sub onButtonSelected()
    if (m.isActionInProcess = false)
        OnUserAction()
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    if (press)
        print "ProfileView OnKeyEvent: press " press " key : " key
        if key = "OK"
            if m.userAction.hasFocus()
                onButtonSelected()
            end if
        end if
    end if

    return result
end function
