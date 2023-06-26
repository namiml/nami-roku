sub init()
    m.scene = m.top.getScene()
    m.top.observeField("visible", "onVisibleChange")

    m.lDeviceId = m.top.findNode("lDeviceId")
    m.lUserInfo = m.top.findNode("lUserInfo")
    m.lJourneyState = m.top.findNode("lJourneyState")
    m.lInstruction = m.top.findNode("lInstruction")

    m.isFirstTime = false
end sub

sub onVisibleChange(event as dynamic)
    isVisible = event.getData()
    if isVisible
        m.lInstruction.setFocus(true)
        updateProfileView()
    else
    end if
end sub

sub updateProfileView()

    m.isActionInProcess = false
    m.scene = m.top.getScene()
    m.namiSDK = m.scene.findNode("namiSDK")
    m.namiCustomerManager = m.namiSDK.findNode("NamiCustomerManagerObj")

    m.lDeviceId.text = "Device ID: " + m.top.namiDataSourceNode.deviceId

    if m.top.namiDataSourceNode.isLoggedIn = true
        m.lInstruction.text = "Press * to logout"
        m.lUserInfo.text = "Registered User: External ID: " + m.top.namiDataSourceNode.loggedInId
    else
        m.lInstruction.text = "Press * to login"
        m.lUserInfo.text = "Anonymous User"
    end if

    m.scene.callFunc("hideLoader")
end sub

sub OnUserAction()
    m.scene.callFunc("showLoader")

    m.top.namiDataSourceNode.unobserveField("isUpdated")
    m.top.namiDataSourceNode.observeField("isUpdated", "OnDataSourceUpdated")

    m.isActionInProcess = true
    if m.top.namiDataSourceNode.isLoggedIn = true
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

sub OnDataSourceUpdated(event as dynamic)
    updateProfileView()
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    print "ProfileView OnKeyEvent: press " press " key : " key
    if (press)
        if key = "options" and m.isActionInProcess = false
            OnUserAction()
            result = true
        end if
    end if

    return result
end function
